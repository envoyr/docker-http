#!/usr/bin/env sh
set -e

LIST_COMMAND="ls -l /data/sites-enabled /data/conf.d"
NEW_FILE_LIST=$($LIST_COMMAND)
while true; do
  if [ "$OLD_FILE_LIST" != "$NEW_FILE_LIST" ]; then
    OLD_FILE_LIST=$NEW_FILE_LIST
    service nginx reload > /dev/null &
    echo "CDN Edge configuration reloaded!"
  fi
  sleep 2 || exit 2
  NEW_FILE_LIST=$($LIST_COMMAND)
done
