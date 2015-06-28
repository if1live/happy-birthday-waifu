#!/bin/bash

export TAG=$1

docker build -t if1live/happy-birthday-waifu:$TAG .
