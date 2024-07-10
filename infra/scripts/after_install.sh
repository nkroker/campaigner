#!/bin/bash
cd /var/www/campaigner
bundle install
RAILS_ENV=production bin/rails db:migrate
RAILS_ENV=production bin/rails assets:precompile
