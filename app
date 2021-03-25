#!/bin/bash

set -e

# Create log file
touch /home/app/docker.log

# Fix permissions (just in case)
chown -R app:app /home/app

# Clone git repository if needed
if [ ! -z "$GIT_REPOSITORY_URL" ]; then
    echo "Cloning from git repository..."
    find /var/www/app -mindepth 1 -depth -exec rm -rf {} ';'
    sudo -u app git clone "$GIT_REPOSITORY_URL" /var/www
fi

# Run deployer if needed
if [ ! -z "$DEPLOYER" ]; then
    echo "Create symbolic link for deployer nginx configuration..."
    ln -s -f /etc/nginx/sites-available/deployer /etc/nginx/sites-enabled/default

    echo "Running deployer..."
    sudo -u app dep deploy
fi

# Start php & nginx in background
service php7.4-fpm start > /dev/null &
service nginx start > /dev/null &

# Return start notice and logs
echo "All services are up for $VIRTUAL_HOST!"
tail -fqn0 /home/app/docker.log \
    /var/log/nginx/access.log \
    /var/log/nginx/error.log
