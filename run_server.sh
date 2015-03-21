#!/bin/bash
source env.sh
RAILS_ENV=production bundle exec unicorn -c config/unicorn.rb -D

