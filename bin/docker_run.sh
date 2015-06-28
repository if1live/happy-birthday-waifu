#!/bin/bash

source env.sh

export TAG=$1

docker stop hbw-$TAG
docker rm hbw-$TAG

docker run --name hbw-$TAG \
	-e SECRET_KEY_BASE=$SECRET_KEY_BASE \
	-e TWITTER_APP_KEY=$TWITTER_APP_KEY \
	-e TWITTER_APP_SECRET=$TWITTER_APP_SECRET \
  -e TWITTER_ACCESS_TOKEN=$TWITTER_ACCESS_TOKEN \
  -e TWITTER_ACCESS_TOKEN_SECRET=$TWITTER_ACCESS_TOKEN_SECRET \
	-e ADMIN_PASSWORD=$ADMIN_PASSWORD \
	-d -p 8002:5000 if1live/happy-birthday-waifu:$TAG
