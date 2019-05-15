FROM php:7.3-fpm

MAINTAINER dongdavid

RUN apt-get update \
    && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install redis-4.0.1 \
#    && pecl install xdebug-2.6.0 \xdebug
    && docker-php-ext-enable redis \
    && docker-php-ext-install -j$(nproc) bcmath \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-install -j$(nproc) mysqli 

EXPOSE 9000
VOLUME ["/data"]
# docker run -d --name php-fpm -v $PWD/data:/data file-test:latest
# docker run -d --name nginxs -v $PWD/data:/data -p 80:80  nginx:latest
# docker build -t dongdavid/php-fpm:7.2 .
