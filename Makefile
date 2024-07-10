# Makefile for Smooth running and deployments

# Stack name with timestamp
STACK_NAME := campaigner-stack

# Github Configs
REPO_OWNER := nkroker
REPO_NAME := campaigner
BRANCH := main

# Command Registry
.PHONY: echo deploy destroy-stack setup stack-deploy key-pair create-policy

setup: ## Run setup script
	bin/setup

echo:
	echo ${SHELL}

create-policy:
	aws iam create-policy \
		--policy-name campaigner-deployment-policy \
		--policy-document file://infra/policy.json

key-pair:
	if aws ec2 describe-key-pairs --key-names campaigner-key 2>&1 | grep -q 'InvalidKeyPair.NotFound'; then \
		aws ec2 create-key-pair --key-name campaigner-key --query 'KeyMaterial' --output text > infra/keys/campaigner-key.pem; \
		chmod 400 infra/keys/campaigner-key.pem; \
		echo "==== Key pair 'campaigner-key' created and saved to infra/keys/campaigner-key.pem ===="; \
	else \
		echo "==== Key pair 'campaigner-key' already exists. ===="; \
	fi

destroy-stack:
	rm -rf infra/keys/campaigner-key.pem
	aws cloudformation delete-stack --stack-name ${STACK_NAME}

# For deploying the latest commit from GitHub
deploy:
	$(eval LATEST_COMMIT_ID := $(shell curl -H "Authorization: token $(GITHUB_OAUTH_TOKEN)" -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/$(REPO_OWNER)/$(REPO_NAME)/commits/$(BRANCH) | jq -r '.sha'))
	aws deploy create-deployment \
		--application-name CampaignerApp \
		--deployment-group-name CampaignerDeploymentGroup \
		--source
		--revision revisionType=GitHub,gitHubLocation.repository=${REPO_OWNER}/${REPO_NAME},gitHubLocation.commitId=$(LATEST_COMMIT_ID) \
		--description "Deploying latest commit to Campaigner"


stack-deploy: key-pair
	aws cloudformation create-stack --stack-name ${STACK_NAME} \
		--template-body file://infra/template.yml \
		--capabilities CAPABILITY_IAM \
		--parameters \
			ParameterKey=KeyName,ParameterValue=campaigner-key \
			ParameterKey=InstanceType,ParameterValue=t3.micro \
			ParameterKey=DBUser,ParameterValue=${AWS_RDS_USER} \
			ParameterKey=DBPassword,ParameterValue=${AWS_RDS_PASSWORD} \
			ParameterKey=DBAllocatedStorage,ParameterValue=20 \
			ParameterKey=GitHubRepository,ParameterValue=nkroker/campaigner \
			ParameterKey=GitHubBranch,ParameterValue=main \
			ParameterKey=GitHubOAuthToken,ParameterValue=${GITHUB_OAUTH_TOKEN}
