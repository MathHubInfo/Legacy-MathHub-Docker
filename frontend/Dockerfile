## Dockerfile for MathHub Docker Web Frontend
## based loosely on https://github.com/docker-library/drupal/tree/master/7

# from https://www.drupal.org/requirements/php#drupalversions
FROM php:7.0-fpm-alpine

# install the PHP extensions we need
# postgresql-dev is needed for https://bugs.alpinelinux.org/issues/3642
RUN set -ex \
	&& apk add --no-cache --virtual .build-deps \
		coreutils \
		freetype-dev \
		libjpeg-turbo-dev \
		libpng-dev \
		postgresql-dev \
	&& docker-php-ext-configure gd \
		--with-freetype-dir=/usr/include/ \
		--with-jpeg-dir=/usr/include/ \
		--with-png-dir=/usr/include/ \
	&& docker-php-ext-install -j "$(nproc)" \
		gd \
		opcache \
		pdo_mysql \
		pdo_pgsql \
		zip \
	&& runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)" \
	&& apk add --virtual .drupal-phpexts-rundeps $runDeps \
	&& apk del .build-deps

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini


## Clone the MathHub source code into /var/www/mathhub.info
RUN apk add --no-cache git \
    && git clone https://github.com/KWARC/Mathhub /var/www/html/ \
    && apk del git


WORKDIR /var/www/html/

## Configure Apache and Drupal accordingly
ADD settings.php /var/www/html/sites/default/

# And finally set a few permissions
RUN chmod 777 /var/www/html/sites/default/files
# TODO: MathHub meta-data init