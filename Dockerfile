FROM php:fpm-alpine AS build-deps

LABEL maintainer="Tony <i@tony.moe>"

RUN apk add --no-cache --virtual .build-deps \
  $PHPIZE_DEPS \
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
    linux-headers \
    make \
    pcre-dev \
    postgresql-dev \
    tidyhtml-dev \
  && PHPIZE_DEPS='' \
  && export PHPIZE_DEPS \
  && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
  && docker-php-ext-install \
    bcmath \
    exif \
    gd \
    gettext \
    intl \
    mysqli \
    pdo_mysql \
    pdo_pgsql \
    pgsql \
    soap \
    sockets \
    tidy \
    zip \
  && pecl install redis \
  && pecl install imagick

RUN docker-php-ext-enable redis imagick

FROM php:fpm-alpine

COPY --from=build-deps /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/
COPY --from=build-deps /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/

RUN runDeps=$( \
    scanelf --needed --nobanner --format '%n#p' /usr/local/lib/php/extensions/*/*.so \
      | tr ',' '\n' \
      | sort -u \
      | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
  ) \
  && apk add --no-cache --virtual .php-rundeps git $runDeps

COPY php /usr/local/etc/php
COPY php-fpm.d /usr/local/etc/php-fpm.d

ENTRYPOINT ["php-fpm"]
