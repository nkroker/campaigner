#!/bin/bash
cd /var/www/campaigner
bundle exec rails s -h 0.0.0.0 -p 3000
sudo service nginx restart
