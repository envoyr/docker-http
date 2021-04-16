# Docker HTTP

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

> 🧨 This feature is currently in beta!

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

## Development build

Run the following command to run the bleeding-edge image of envoyr/http on a Docker container:

````
docker run -p 80:80 envoyr/http:edge
````

## License

This project is licensed under the terms of the MIT License.
