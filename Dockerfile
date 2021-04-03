FROM ubuntu:focal

# Set timezone
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Update and install core components
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y \
    software-properties-common \
    sudo \
    unzip \
    nginx \
    wget \
    git \
    acl

# Install php components
RUN add-apt-repository ppa:ondrej/php -y
RUN apt-get install -y \
    php7.4-fpm \
    php7.4-cli \
    php7.4-curl \
    php7.4-mysql \
    php7.4-mbstring \
    php7.4-zip \
    php7.4-xml \
    php7.4-gd

# Install deployer
RUN wget https://deployer.org/deployer.phar -O /usr/local/bin/dep
RUN chmod +x /usr/local/bin/dep

# Setup nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY nginx/sites-enabled/default /etc/nginx/sites-enabled/default
COPY nginx/sites-available/deployer /etc/nginx/sites-available/deployer
COPY nginx/snippets/fastcgi-php.conf /etc/nginx/snippets/fastcgi-php.conf

# Setup php-fpm pool
COPY php/7.4/fpm/pool.d/app.conf /etc/php/7.4/fpm/pool.d/app.conf

# Setup composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Setup system user to run composer and artisan commands
RUN useradd -G www-data,root -u 1000 -d /home/app app

# Setup web assets
COPY www /home/app/www

# Setup directories, set permissions
RUN mkdir -p /home/app/.composer && \
    chown -R app:app /home/app

# Setup app file
COPY app /usr/local/bin/app

# Expose default port
EXPOSE 80

# Set stopsignal
STOPSIGNAL SIGKILL

# Set working directory
WORKDIR /home/app

# Start app
CMD ["bash", "/usr/local/bin/app"]
