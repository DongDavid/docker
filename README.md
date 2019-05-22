# Docker启动nginx+php-fpm环境

## 命令

```
# 启动
docker-compose up
# 暂停
ctrl+c 

# 后台启动
docker-compose up -d

# 暂停
docker-compose stop

# 启动
docker-compose start

# 删除
docker-compose down

```

## 配置文件

`conf.d`是nginx的站点配置文件目录  
工程文件放在data目录的app目录中  
工程的启动文件路径默认为`./data/app/public`  
默认访问路径为`http://localhost`  
若要修改则需要修改nginx的配置文件`conf.d/*.conf`  
php的扩展则需要在Dockerfile中修改  
需要增加redis或者Mysql等则需要在docker-compose.yml里面修改


## 目录

```
|____docker
| |____Dockerfile
| |____default.conf
| |____docker-compose.yml
|____data
| |____host.access.log
| |____app
| | |____public
| | | |____index.php
| |____app1
| | |____public
| | | |____index.php
| |____.gitignore
```

## 快速上手

启动
```
git clone https://gogs.dongdavid.com/dongdavid/docker.git docker-lnmp
cd docker-lnmp
cd data
composer create-project topthink/think app
cd ../docker
docker-compose up
```

如果需要支持多站点,则需要在nginx的配置文件中设置server_name,并且修改本机`hosts`文件

删除
```
docker-composer down
rm -rf docker-lnmp
```

如果只需要单纯的静态文件服务器,则在目标路径执行以下命令即可
```
docker run -d --name qwerdf -p 80:80 -v $PWD:/usr/share/nginx/html nginx:latest
```

## todolist  

* 增加一个脚本用于快速创建一个站点。

## 其他

(PHP镜像配置说明)[https://hub.docker.com/_/php]
> 注意需要在Docker Desktop中配置Proxies,否则在容器中执行apt-get的时候会因为网络问题导致更新失败

```
FROM php:7.2-fpm

MAINTAINER dongdavid

RUN apt-get update \
    && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install redis-4.0.1 \
    && pecl install xdebug-2.6.0 \
    && docker-php-ext-enable redis xdebug imagick \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-install -j$(nproc) mysqli 

EXPOSE 9000
VOLUME ["/data"]
# docker build -t dongdavid/php-fpm:7.2 .
# docker run -d --name php-fpm -v $PWD/../data:/data dongdavid/php-fpm:7.2:7.2
# docker run -d --name nginxs -v $PWD/../data:/data -v $PWD/default.conf:/ext/nginx/conf.d/default.conf -p 80:80  nginx:latest

```

## 一个参考(https://hub.docker.com/r/crunchgeek/php-fpm)

```
FROM php:7.2-fpm

MAINTAINER Mark Hilton <nerd305@gmail.com>

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        libmemcached-dev \
        libz-dev \
        libpq-dev \
        libssl-dev libssl-doc libsasl2-dev \
        libmcrypt-dev \
        libxml2-dev \
        zlib1g-dev libicu-dev g++ \
        libldap2-dev libbz2-dev \
        curl libcurl4-openssl-dev \
        libenchant-dev libgmp-dev firebird-dev libib-util \
        re2c libpng++-dev \
        libwebp-dev libjpeg-dev libjpeg62-turbo-dev libpng-dev libvpx-dev libfreetype6-dev \
        libmagick++-dev \
        libmagickwand-dev \
        zlib1g-dev libgd-dev \
        libtidy-dev libxslt1-dev libmagic-dev libexif-dev file \
        sqlite3 libsqlite3-dev libxslt-dev \
        libmhash2 libmhash-dev libc-client-dev libkrb5-dev libssh2-1-dev \
        unzip libpcre3 libpcre3-dev \
        poppler-utils ghostscript libmagickwand-6.q16-dev libsnmp-dev libedit-dev libreadline6-dev libsodium-dev \
        freetds-bin freetds-dev freetds-common libct4 libsybdb5 tdsodbc libreadline-dev librecode-dev libpspell-dev

# fix for docker-php-ext-install pdo_dblib
# https://stackoverflow.com/questions/43617752/docker-php-and-freetds-cannot-find-freetds-in-know-installation-directories
RUN ln -s /usr/lib/x86_64-linux-gnu/libsybdb.so /usr/lib/

RUN docker-php-ext-configure hash --with-mhash && \
    docker-php-ext-install hash
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install imap iconv

RUN docker-php-ext-install bcmath bz2 calendar ctype curl dba dom enchant 
RUN docker-php-ext-install fileinfo exif ftp gd gettext gmp 
RUN docker-php-ext-install interbase intl json ldap mbstring mysqli 
RUN docker-php-ext-install opcache pcntl pspell
RUN docker-php-ext-install pdo pdo_dblib pdo_mysql pdo_pgsql pdo_sqlite pgsql phar posix 
RUN docker-php-ext-install readline recode 
RUN docker-php-ext-install session shmop simplexml soap sockets sodium 
RUN docker-php-ext-install sysvmsg sysvsem sysvshm 
# RUN docker-php-ext-install snmp

# fix for docker-php-ext-install xmlreader
# https://github.com/docker-library/php/issues/373
RUN export CFLAGS="-I/usr/src/php" && docker-php-ext-install xmlreader xmlwriter xml xmlrpc xsl

RUN docker-php-ext-install tidy tokenizer wddx zend_test zip

# already build in... what they say...
# RUN docker-php-ext-install filter reflection spl standard 
# RUN docker-php-ext-install pdo_firebird pdo_oci 

# install pecl extension
RUN pecl install ds && \
    pecl install imagick && \
    pecl install igbinary && \
    pecl install mongodb && \
    pecl install ssh2-1.0 && \
    pecl install redis-4.0.1 && \
    pecl install xdebug-2.6.0 && \
    pecl install memcached-3.0.4 && \
    docker-php-ext-enable ds imagick igbinary ssh2 redis memcached mongodb xdebug

RUN yes "" | pecl install msgpack && \
    docker-php-ext-enable msgpack

# install the php memcache extension
RUN set -x \
    && cd /tmp \
    && curl -sSL -o php7.zip https://github.com/websupport-sk/pecl-memcache/archive/php7.zip \
    && unzip php7 \
    && cd pecl-memcache-php7 \
    && /usr/local/bin/phpize \
    && ./configure --with-php-config=/usr/local/bin/php-config \
    && make \
    && make install \
    && echo "extension=memcache.so" > /usr/local/etc/php-fpm.d/docker-php-ext-memcache.ini \
    && rm -rf /tmp/pecl-memcache-php7 php7.zip

# install APCu
RUN pecl install apcu-5.1.8 && \
    pecl install apcu_bc-1.0.3 && \
    docker-php-ext-enable apcu --ini-name docker-php-ext-10-apcu.ini && \
    docker-php-ext-enable apc  --ini-name docker-php-ext-20-apc.ini

# oracle database 
# RUN curl -o /tmp/instantclient-sdk.zip   -L https://github.com/bumpx/oracle-instantclient/raw/master/instantclient-sdk-linux.x64-12.1.0.2.0.zip && \
#     curl -o /tmp/instantclient-basic.zip -L https://github.com/bumpx/oracle-instantclient/raw/master/instantclient-basic-linux.x64-12.1.0.2.0.zip
# RUN unzip /tmp/instantclient-basic.zip -d /usr/local/ && \
#     unzip /tmp/instantclient-sdk.zip -d /usr/local/ && \
#     ln -s /usr/local/instantclient_12_1 /usr/local/instantclient && \
#     ln -s /usr/local/instantclient/libclntsh.so.12.1 /usr/local/instantclient/libclntsh.so && \
#     docker-php-ext-configure oci8 --with-oci8=instantclient,/usr/local/instantclient && \
#     docker-php-ext-install oci8

# install MSSQL support and ODBC driver
RUN apt-get update -y && apt-get install -y apt-transport-https locales gnupg
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/8/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    export DEBIAN_FRONTEND=noninteractive && apt-get update -y && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql unixodbc-dev
RUN set -xe \
    && pecl install pdo_sqlsrv \
    && docker-php-ext-enable pdo_sqlsrv \
    && apt-get purge -y unixodbc-dev && apt-get autoremove -y && apt-get clean

# install GD
RUN docker-php-ext-configure gd \
        --enable-gd-native-ttf \
        --with-png-dir=/usr/include \
        --with-jpeg-dir=/usr/lib/x86_64-linux-gnu \
        --with-xpm-dir=/usr/include \
        --with-webp-dir=/usr/include \
        --with-freetype-dir=/usr/include && \
    docker-php-ext-install -j$(nproc) gd

# set locale to utf-8
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'



#--------------------------------------------------------------------------
# Final Touches
#--------------------------------------------------------------------------

# install required libs for health check and cron
RUN apt-get -y install libfcgi0ldbl supervisor nano cron

# crontab fix: https://stackoverflow.com/questions/43323754/cannot-make-remove-an-entry-for-the-specified-session-cron
RUN sed -i '/session    required     pam_loginuid.so/c\#session    required   pam_loginuid.so' /etc/pam.d/cron

# install NewRelic agent
RUN echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' | tee /etc/apt/sources.list.d/newrelic.list && \
    curl https://download.newrelic.com/548C16BF.gpg | apt-key add - && \
    apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install newrelic-php5 newrelic-sysmond && \
    export NR_INSTALL_SILENT=1 && newrelic-install install

# install SendGrid
RUN echo "postfix postfix/mailname string localhost" | debconf-set-selections && \
    echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get install postfix libsasl2-modules -y

# install shared PHP code
RUN git clone https://github.com/nrk/predis.git /usr/local/lib/php/predis && \
    git clone https://github.com/markhilton/redis-http-cache.git /usr/local/lib/php/redis-http-cache

# Set default work directory
ADD scripts/* /usr/local/bin/
RUN chmod +x  /usr/local/bin/*

# install aliases for Laravel
RUN echo "" >> ~/.bashrc && \
    echo "# Load Custom Aliases" >> ~/.bashrc && \
    echo "source /usr/local/bin/aliases.sh" >> ~/.bashrc && \
    echo "" >> ~/.bashrc && \
    sed -i 's/\r//' /usr/local/bin/aliases.sh && \
    sed -i 's/^#! \/bin\/sh/#! \/bin\/bash/' /usr/local/bin/aliases.sh

# Clean up
RUN apt-get remove -y git && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# allow all processes to write to the same log
RUN touch /tmp/stdout.log && \
    chmod u+rw,g+rw,o+rw /tmp/stdout.log

# Health check
RUN echo '#!/bin/bash' > /healthcheck && \
    echo 'php -v > /dev/null || exit 1' >> /healthcheck && \
    echo 'SCRIPT_NAME=/status SCRIPT_FILENAME=/status REQUEST_METHOD=GET cgi-fcgi -bind -connect 127.0.0.1:9000' >> /healthcheck && \
    chmod +x /healthcheck

HEALTHCHECK --interval=5s --timeout=3s CMD /healthcheck || exit 1

WORKDIR /app

```