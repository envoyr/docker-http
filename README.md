# Docker HTTP

> 🧨 This version **2.0** branch is still in development and has breaking changes with version **1.x** !

![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/envoyr/http)
![Docker Cloud Build status](https://img.shields.io/docker/cloud/build/envoyr/http)

## Documentation

* Default port is `80`
* Current php version is `8.0`

## Use with docker-compose

### Default

````
version: "3"
services:
  app:
    image: envoyr/http:latest
    volumes:
      - ./www:/app/www
````

### Proxy

````
version: "3"
services:
  app:
    image: envoyr/http:latest
    environment:
      - MODE=proxy
      - PROXY_HOST=example.com
      - PROXY_PASS=https://example.com:80
````

### Deployer

> 🧨 This feature is currently untested!

````
version: "3"
services:
  app:
    image: envoyr/http:latest
      - MODE=deployer
    volumes:
      - ./deploy.php:/app/deploy.php
      - ./www/shared:/app/www/shared
````

#### Deploy after creation

Deploy with zero downtime after making changes on git:

````
docker-compose exec app dep deploy
````

### Install additional packages

> 🧨 This feature is currently untested!

````
services:
  app:
    image: envoyr/http:latest
    environment:
      - APT_INSTALL=php-redis
    # ...
````

### In conjunction with the `docker-letsencrypt-nginx-proxy`:

````
version: "3"
services:
  app:
    image: envoyr/http:latest
    environment:
      - VIRTUAL_HOST=app.example.com
      - LETSENCRYPT_HOST=app.example.com
````

## License

This project is licensed under the terms of the MIT License.
