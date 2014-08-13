FROM phusion/baseimage:0.9.9

# Set correct environment variables.
ENV	HOME /root
ENV	LANG en_US.UTF-8
ENV	LC_ALL en_US.UTF-8
ENV	DEBIAN_FRONTEND	noninteractive

# set sane locale
RUN	locale-gen en_US.UTF-8

RUN echo "deb http://archive.ubuntu.com/ubuntu saucy main universe" > /etc/apt/sources.list
RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:nginx/development && apt-get update

RUN apt-get install -y wget \
                    geoip-bin \
                    geoip-database \
                    libgeoip-dev \
                    curl \
                    make \
                    build-essential \
                    libgd2-dev \
                    libreadline-dev \
                    libncurses5-dev \
                    libpcre3-dev \
                    libssl-dev \
                    libxslt1-dev \
                    perl \
                    supervisor \
                    openssh-server
# add GeoIP support
RUN cd /usr/share/GeoIP; wget -c http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz; gunzip GeoLiteCity.dat.gz
RUN cp /etc/GeoIP.conf.default /etc/GeoIP.conf
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config
ENV NGINX_VERSION 1.7.4
ENV NGINX_STICKY_VERSION 1.2.5
ENV NGINX_STICKY_HASH bd312d586752
RUN cd /opt; \
    wget -c https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng/get/$NGINX_STICKY_VERSION.tar.gz --output-document=nginx-sticky-module-ng-$NGINX_STICKY_HASH.tar.gz; \
    tar xvf nginx-sticky-module-ng-$NGINX_STICKY_HASH.tar.gz; \
    wget -c http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz;\
    tar xvf nginx-$NGINX_VERSION.tar.gz; \
    cd nginx-$NGINX_VERSION; \
    ./configure --with-http_geoip_module \
                --with-file-aio \
                --with-http_ssl_module \
                --with-http_spdy_module \
                --with-http_geoip_module \
                --with-http_gunzip_module \
                --with-http_gzip_static_module \
                --with-http_image_filter_module \
                --with-http_realip_module \
                --with-http_sub_module \
                --with-pcre-jit \
                --with-http_stub_status_module \
                --add-module=../nginx-goodies-nginx-sticky-module-ng-$NGINX_STICKY_HASH ;\
    make;\
    make install

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD set_root_pw.sh /set_root_pw.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh

# Attach volumes.
VOLUME /usr/local/nginx/conf/sites-enabled
VOLUME /usr/local/nginx/conf/includes
VOLUME /usr/local/nginx/logs
VOLUME /usr/local/nginx/html
VOLUME /opt/uploaded

# Expose ports.
EXPOSE 80 443

CMD ["/run.sh"]

# Clean up APT when done.
RUN	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
