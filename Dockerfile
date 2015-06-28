FROM ruby:2.2.2
MAINTAINER if1live <libsora25@gmail.com>

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN \
  apt-get update &&\
  apt-get install -qq -y git sudo

RUN	\
  apt-get install -qq -y redis-server libmysqlclient-dev

# Install foreman
RUN \
  wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh

RUN \
  mkdir -p /var/www/

RUN \
  cd /var/www &&\
  git clone https://github.com/if1live/happy-birthday-waifu.git

RUN \
  mkdir -p /var/www/happy-birthday-waifu/tmp/pids/ &&\
  mkdir -p /var/www/happy-birthday-waifu/log/

WORKDIR /var/www/happy-birthday-waifu

ENV PORT 5000
ENV RACK_ENV production
ENV RAILS_ENV production

RUN gem install bundler
RUN bundle install

EXPOSE 5000
CMD \
  echo "TWITTER_APP_KEY=$TWITTER_APP_KEY" &&\
  echo "TWITTER_APP_SECRET=$TWITTER_APP_SECRET" &&\
  /etc/init.d/redis-server start &&\
  bundle exec rake db:create &&\
  bundle exec rake db:migrate &&\
  bundle exec rake db:seed &&\
  bundle exec rake assets:precompile &&\
  foreman start


  
