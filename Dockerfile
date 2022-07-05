FROM ubuntu:focal

# Set timezone
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Update and install core components
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y \
    software-properties-common gettext-base sudo unzip nginx wget git acl supervisor

# Install php components
RUN add-apt-repository ppa:ondrej/php -y
RUN apt-get install -y \
    php8.1-fpm php8.1-cli php8.1-curl php8.1-mysql php8.1-mbstring php8.1-zip php8.1-xml php8.1-gd

# Setup php-fpm pool
COPY etc/php/8.1/fpm/pool.d/app.conf /etc/php/8.1/fpm/pool.d/app.conf

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install deployer
RUN wget https://deployer.org/deployer.phar -O /usr/local/bin/dep
RUN chmod +x /usr/local/bin/dep

# Setup nginx
COPY errors /usr/share/nginx/html/nginx-errors/errors
COPY etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY etc/nginx/snippets /etc/nginx/snippets
COPY etc/nginx/conf.d /etc/nginx/conf.d

# Redirect logs
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

# Setup system user to run composer and artisan commands
RUN useradd -G www-data,root -u 1000 -d /app app

# Set working directory
WORKDIR /app

# Setup web assets
COPY www /app/www

# Setup directories, set permissions
RUN mkdir -p /app/.composer && \
    chown -R app:app /app

# Add entrypoint
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

# Set stopsignal
STOPSIGNAL SIGKILL

# Prepare folders and files
COPY etc/supervisor/conf.d /etc/supervisor/conf.d
RUN mkdir -p /var/log/supervisor
COPY bin /opt/bin

# Start supervisord
CMD ["/usr/bin/supervisord", "--loglevel", "warn"]
