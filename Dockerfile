FROM php:8.1-alpine

ENV WEB_DOCUMENT_ROOT "/app/public"
WORKDIR /app

RUN apk update \
    && apk upgrade

####################################
#
#  Base Packages
#
####################################

# Setup Zip
RUN apk add --virtual zip unzip git libzip-dev \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip \
    && docker-php-source extract \
	&& docker-php-ext-install bcmath ctype fileinfo \
	&& docker-php-source delete

# Setup Required PHP Extensions
RUN apk add oniguruma-dev \
    && docker-php-ext-install mbstring \
    && docker-php-ext-enable mbstring \
    && rm -rf /tmp/*

RUN docker-php-ext-install pdo pdo_mysql \
    && docker-php-ext-enable pdo pdo_mysql \
    && rm -rf /tmp/*

RUN apk add postgresql-libs postgresql-dev \
    && docker-php-ext-install pdo pdo_pgsql pgsql \
    && docker-php-ext-enable pdo pdo_pgsql \
    && rm -rf /tmp/*

# Customize PHP
ENV PHP_DISMOD=ioncube,mongodb

# Install Opcache
RUN docker-php-ext-install opcache
COPY ./etc/opcache/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# Install Nginx
RUN apk add nginx \
    nano \
    procps \
    bash \
    curl \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-install pcntl

####################################
#
#  Swoole for Laravel Octane
#
####################################

RUN \
    apk add --no-cache libstdc++ libpq && \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS curl-dev openssl-dev pcre-dev pcre2-dev zlib-dev && \
    docker-php-ext-install sockets && \
    docker-php-source extract && \
    mkdir /usr/src/php/ext/swoole && \
    curl -sfL https://github.com/swoole/swoole-src/archive/master.tar.gz -o swoole.tar.gz && \
    tar xfz swoole.tar.gz --strip-components=1 -C /usr/src/php/ext/swoole && \
    docker-php-ext-configure swoole \
        --enable-http2        \
        --enable-mysqlnd      \
        --enable-swoole-pgsql \
        --enable-openssl      \
        --enable-sockets --enable-swoole-curl --enable-swoole-json && \
    docker-php-ext-install -j$(nproc) swoole && \
    rm -f swoole.tar.gz $HOME/.composer/*-old.phar && \
    docker-php-source delete && \
    apk del .build-deps


####################################
#
#  Nginx
#
####################################

# Nginx Error Pages
COPY --chown=nginx:nginx ./etc/nginx/extras/0-exclude-php.conf /etc/nginx/extras/0-exclude-php.conf
COPY --chown=nginx:nginx ./etc/nginx/extras/10-error-pages.conf /etc/nginx/extras/10-error-pages.conf
COPY --chown=nginx:nginx ./error-pages/404.html /var/www/html/404.html
COPY --chown=nginx:nginx ./error-pages/500.html /var/www/html/500.html

# Nginx Setup Config
COPY ./etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./etc/nginx/extras/nginx-large-headers.conf /etc/nginx/extras/01-larger-headers.conf
COPY ./etc/nginx/extras/forward-ip.conf /etc/nginx/extras/20-forward-ip.conf
COPY ./etc/nginx/extras/gzip.conf /etc/nginx/extras/20-gzip.conf
RUN rm -rf /etc/nginx/http.d/*
COPY ./etc/nginx/http.d/location-root.conf /etc/nginx/http.d/10-location-root.conf

# PHP Setup Config
COPY ./etc/php/php-post-size.ini /usr/local/etc/php/conf.d/php-post-size.ini

# Setup PHP and Nginx
COPY bash/octane.sh /usr/local/bin/octane-start
RUN chmod u+x /usr/local/bin/octane-start

COPY ./bash/nginx.sh /usr/local/bin/nginx-start
RUN chmod u+x /usr/local/bin/nginx-start

####################################
#
#  Start and Monitor Processes
#
####################################

COPY ./bash/start.sh /usr/local/bin/start
RUN chmod u+x /usr/local/bin/start

CMD ["/usr/local/bin/start"]