#!/bin/bash
sudo su
cd /home/ec2-user/app
gem install bundler -v 2.5.10
bundle _2.5.10_ install
RAILS_ENV=production bin/rails db:migrate
RAILS_ENV=production bin/rails assets:precompile
