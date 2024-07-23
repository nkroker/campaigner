#!/bin/bash

# Redirect stdout and stderr to a log file
exec > >(tee -i /home/ec2-user/app/deployment.log)
exec 2>&1

cd /home/ec2-user/app || { echo "Failed to change directory to /home/ec2-user/app"; exit 1; }

# Log the start time
echo "Script started at $(date)"

# Check available memory and disk space
echo "Checking available memory and disk space..."
free -m
df -h

# Add swap space if needed
echo "Adding swap space..."
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

sudo yum install -y mysql-community-client mysql-devel --allowerasing

# Install the bundler gem
echo "Installing bundler..."
sudo gem install bundler -v 2.5.10
if [ $? -eq 0 ]; then
  echo "Bundler installation successful"
else
  echo "Bundler installation failed" >&2
  exit 1
fi

# Install the gems specified in the Gemfile
echo "Installing gems with bundler..."
bundle _2.5.10_ install
if [ $? -eq 0 ]; then
  echo "Gems installation successful"
else
  echo "Gems installation failed" >&2
  exit 1
fi

# Ensure bundler is in the path
export PATH="/usr/local/bin:$PATH"

# Prepare the database
echo "Setting up the database..."
bundle exec rails db:prepare
if [ $? -eq 0 ]; then
  echo "DB setup successful"
else
  echo "DB setup failed" >&2
  exit 1
fi

# Log the end time
echo "Script completed at $(date)"
