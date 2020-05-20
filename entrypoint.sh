#!/bin/sh
# this file is needed for the Heroku deploy only!

set -e
config_file="/etc/nginx/conf.d/default.conf"

if [[ -z "$PORT" ]] ; then
  echo "Error: PORT not defined!"
  exit 0
fi

search_query="80"
grep "$search_query" "$config_file"
sed -i "s,$search_query,$PORT,g" "$config_file"

nginx -g 'daemon off;'