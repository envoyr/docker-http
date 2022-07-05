#!/usr/bin/env sh
set -e

# Start php8.0-fpm in background
service php8.0-fpm start > /dev/null &

echo "Services started in $MODE mode!"
exec "$@"
