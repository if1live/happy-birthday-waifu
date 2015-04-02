#!/bin/bash
source env.sh

function setup_server {
	RAILS_ENV=production bundle exec rake db:migrate
	RAILS_ENV=production bundle exec rake db:seed
	RAILS_ENV=production bundle exec rake assets:precompile
}

function run_server {
	RAILS_ENV=production bundle exec unicorn -c config/unicorn.rb -D
}

function kill_server {
	PID=$(ps aux|grep "unicorn master"|grep "\-D"|awk '{ print $2}')
	kill $PID
}

function kill_sidekiq {
	PID=$(ps aux|grep "sidekiq"|grep "happy"|awk '{ print $2}')
	kill $PID
}

function run_sidekiq {
	bundle exec sidekiq -C config/sidekiq.yml -e production -d
}

setup_server
kill_server
run_server

kill_sidekiq
run_sidekiq
