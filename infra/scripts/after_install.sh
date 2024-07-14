#!/bin/bash
cd /home/ec2-user/app
sudo gem install bundler -v 2.5.10
bundle _2.5.10_ install
bundle exec rails db:prepare
