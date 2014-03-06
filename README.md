## Nginx Dockerfile

Same as [dockerfile/nginx](https://index.docker.io/u/dockerfile/nginx/) but
with `nginx mainline` instead of `stable`.

This repository contains **Dockerfile** of [Nginx](http://nginx.org/) for [Docker](https://www.docker.io/)'s [trusted build](https://index.docker.io/u/klaemo/nginx/) published to the public [Docker Registry](https://index.docker.io/).


### Dependencies

* [ubuntu:13.10](https://index.docker.io/u/_/ubuntu)


### Installation

1. Install [Docker](https://www.docker.io/).

2. Download [trusted build](https://index.docker.io/u/klaemo/nginx/) from public [Docker Registry](https://index.docker.io/): `docker pull klaemo/nginx`

   (alternatively, you can build an image from Dockerfile: `docker build -t="klaemo/nginx" github.com/klaemo/nginx`)


### Usage

    docker run -d -p 80:80 klaemo/nginx

#### Attach persistent/shared directories

    docker run -d -p 80:80 -v <sites-enabled-dir>:/etc/nginx/sites-enabled -v <log-dir>:/var/log/nginx klaemo/nginx

Open `http://<host>` to see the welcome page.