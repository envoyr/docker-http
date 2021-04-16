#!/usr/bin/env sh
set -e

# Clone git repository if needed
if [ -n "$GIT_REPOSITORY_URL" ]; then
    echo "Cloning from git repository..."
    rm -R /app/www && sudo -u app git clone "$GIT_REPOSITORY_URL" /var/www
fi

# Install packages
if [ -n "$APT_INSTALL" ]; then
  echo "Starting with additional packages $APT_INSTALL"
  apt-get install -y -qq "$APT_INSTALL"
fi

# Loading config
if [ "$MODE" = "proxy" ]; then
  # Generate proxy from template
  # shellcheck disable=SC2016
  envsubst '${PROXY_HOST} ${PROXY_PASS}' < /etc/nginx/conf.d/default-proxy.conf.template > /etc/nginx/conf.d/default.conf
elif [ "$MODE" = "deployer" ]; then
  # Generate deployer from template
  cp /etc/nginx/conf.d/default-deployer.conf.template /etc/nginx/conf.d/default.conf
  dep deploy
else
  # Generate default from template
  cp /etc/nginx/conf.d/default.conf.template /etc/nginx/conf.d/default.conf
fi

# Start php8.0-fpm in background
service php8.0-fpm start > /dev/null &

echo "Services started in $MODE mode!"
exec "$@"
