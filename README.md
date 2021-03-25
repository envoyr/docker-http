# Docker HTTP

![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/envoyr/http)
![Docker Cloud Build status](https://img.shields.io/docker/cloud/build/envoyr/http)

## Documentation

### Use with docker-compose

Spin up new server:

````
version: "3"
services:
  app:
    image: envoyr/http:latest
    volumes:
      - ./services/app/www:/home/app/www
````

with deployer enabled:

````
version: "3"
services:
  app:
    image: envoyr/http:latest
    environment:
      - DEPLOYER=1
    volumes:
      - ./services/app/deploy.php:/home/app/deploy.php
      - ./services/app/shared:/home/app/www/shared
````

in conjunction with the docker-letsencrypt-nginx-proxy:

````
version: "3"
services:
  app:
    image: envoyr/http:latest
    environment:
      - VIRTUAL_HOST=app.example.com
      - LETSENCRYPT_HOST=app.example.com
      - DEPLOYER=1
    volumes:
      - ./services/app/deploy.php:/home/app/deploy.php
      - ./services/app/shared:/home/app/www/shared
````

#### Deploy after creation

Deploy with zero downtime after making changes on git:

````
docker-compose exec app dep deploy
````

## License

This project is licensed under the terms of the MIT License.
