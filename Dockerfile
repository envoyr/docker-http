FROM ubuntu:focal

# Set timezone
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Update and install core components
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y \
    software-properties-common gettext-base sudo unzip nginx wget git acl

# Install php components
RUN add-apt-repository ppa:ondrej/php -y
RUN apt-get install -y \
    php8.0-fpm php8.0-cli php8.0-curl php8.0-mysql php8.0-mbstring php8.0-zip php8.0-xml php8.0-gd

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install deployer
RUN wget https://deployer.org/deployer.phar -O /usr/local/bin/dep
RUN chmod +x /usr/local/bin/dep

# Setup nginx
COPY errors /usr/share/nginx/html/nginx-errors/errors
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/snippets /etc/nginx/snippets
COPY nginx/conf.d /etc/nginx/conf.d

# Setup php-fpm pool
COPY php/8.0/fpm/pool.d/app.conf /etc/php/8.0/fpm/pool.d/app.conf

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

# set default environment variables
ENV MODE default
ENV PROXY_HOST \$http_host

# Set stopsignal
STOPSIGNAL SIGKILL

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
