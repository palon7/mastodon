#!/bin/bash

# Check arguments
if [ $# -lt 1 ]; then
  echo "Usage: ./task.sh <command>"
  echo ""
  echo " copy <path>            : Copy file to instance."
  echo " compile-assets         : Precompile assets."
  echo " hot-restart            : Restart web server. (Hot restart)"
  echo " migrate                : Migrate Database."
  echo " daily                  : Run daily task."
  echo " login <instance>       : Login to instance."
  echo " remove-remote          : Remove old media cache."
  echo ""
  exit 1
fi

# FIXME: Webサーバのスケールに対応できない
# TODO: ちゃんと関数にする
if [ $1 == "login" ]; then
  sudo docker exec -it $2 /bin/sh
fi

if [ $1 == "hot-restart" ]; then
  sudo docker exec -it mastodon_web_1 kill -SIGUSR2 1
fi

if [ $1 == "compile-assets" ]; then
  sudo docker exec -it mastodon_web_1 rake assets:precompile
fi

if [ $1 == "confirm-email" ]; then
  sudo docker exec -it mastodon_web_1 rake mastodon:confirm_email USER_EMAIL=$2
fi
if [ $1 == "daily" ]; then
  sudo docker exec -it mastodon_web_1 rake mastodon:daily
fi

if [ $1 == "remove-remote" ]; then
  sudo docker exec -it mastodon_web_1 rake mastodon:media:remove_remote
fi

if [ $1 == "migrate" ]; then
  sudo docker exec -it mastodon_web_1 rake db:migrate
fi

if [ $1 == "copy" ]; then
  if [ $# -ne 2 ]; then
    echo "Usage: ./task.sh copy <path>"
    exit 1
  fi
  sudo docker cp $2 mastodon_web_1:mastodon/$2
fi
