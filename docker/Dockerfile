FROM php:7.2-fpm


ENV PHPREDIS_VERSION 3.1.6
RUN curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz \
    && tar xfz /tmp/redis.tar.gz \
    && rm -r /tmp/redis.tar.gz \
    && mkdir -p /usr/src/php/ext \
    && mv phpredis-$PHPREDIS_VERSION /usr/src/php/ext/redis \
    && docker-php-ext-install redis \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && rm -rf /usr/src/php
EXPOSE 9000
VOLUME ["/data"]
# docker run -d --name php-fpm -v $PWD/data:/data file-test:latest
# docker run -d --name nginxs -v $PWD/data:/data -p 80:80  nginx:latest