FROM php:fpm-alpine

LABEL maintainer="Tony <i@tony.moe>"

RUN curl -sS https://getcomposer.org/installer | php \
  \
  && apk add --no-cache --virtual .build-deps \
    autoconf \
    freetype-dev \
    gettext-dev \
    g++ \
    icu-dev \
    imagemagick-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libxml2-dev \
    libzip-dev \
    make \
    pcre-dev \
    postgresql-dev \
    tidyhtml-dev \
  && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
  && docker-php-ext-configure opcache --enable-opcache \
  && docker-php-ext-install \
    bcmath \
    exif \
    gd \
    gettext \
    iconv \
    intl \
    mysqli \
    opcache \
    pdo_mysql \
    pdo_pgsql \
    pgsql \
    soap \
    sockets \
    tidy \
    xmlrpc \
    zip \
  && pecl install redis \
  && pecl install imagick \
  && docker-php-ext-enable \
    redis \
    imagick \
  \
  && runDeps=$( \
    scanelf --needed --nobanner --format '%n#p' /usr/local/lib/php/extensions/*/*.so \
      | tr ',' '\n' \
      | sort -u \
      | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
  ) \
  && apk add --no-cache --virtual .php-rundeps git $runDeps \
  && apk del .build-deps

COPY php /usr/local/etc/php
COPY php-fpm.d /usr/local/etc/php-fpm.d

CMD ["php-fpm"]