#!/bin/bash
cd /home/ec2-user/app
bundle exec rails s -h 0.0.0.0 -p 3000
sudo service nginx restart
