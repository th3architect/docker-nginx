## Nginx Dockerfile

Same as [dockerfile/nginx](https://index.docker.io/u/dockerfile/nginx/) but
with `nginx mainline` **(1.7.4)** instead of `stable` plus `nginx-sticky-module-ng` **(1.2.5)** for load balancing with sticky session.

This repository contains **Dockerfile** of [Nginx](http://nginx.org/) for [Docker](https://www.docker.io/)'s of forked [trusted build](https://index.docker.io/u/klaemo/nginx/) published to the public [Docker Registry](https://index.docker.io/).


### Dependencies

* [ubuntu:13.10](https://index.docker.io/u/_/ubuntu)


### Installation

1. Install [Docker](https://www.docker.io/).

2. Download [trusted build](https://index.docker.io/u/webdizz/nginx/) from public [Docker Registry](https://index.docker.io/): `docker pull webdizz/nginx`

   (alternatively, you can build an image from Dockerfile: `docker build -t="webdizz/nginx" github.com/webdizz/nginx`)


### Usage

    docker run -d -p 80:80 webdizz/nginx

#### Attach persistent/shared directories

    docker run -d -p 80:80 -p 443:443 -v <sites-enabled-dir>:/etc/nginx/sites-enabled -v <log-dir>:/var/log/nginx webdizz/nginx

#### Attach persistent/shared directories with all required resources externalised

    docker run --name="nginx" -d -e ROOT_PASS="v68y0n82" -p 2222:22 -p 80:80 -p 443:443 \
                -v /vagrant/images/nginx/external/conf/nginx.conf:/usr/local/nginx/conf/nginx.conf \
                -v /vagrant/images/nginx/external/conf/sites-enabled:/usr/local/nginx/conf/sites-enabled \
                -v /vagrant/images/nginx/external/conf/includes:/usr/local/nginx/conf/includes \
                -v /vagrant/images/nginx/external/logs:/usr/local/nginx/logs \
                -v /vagrant/images/nginx/external/static:/usr/local/nginx/html \
                webdizz/nginx

Open `http://<host>` to see the welcome page.
