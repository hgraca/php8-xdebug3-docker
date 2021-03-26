FROM php:8.0.0-fpm

COPY ./etc/php/php.ini $PHP_INI_DIR/
COPY ./etc/php/xdebug.ini $PHP_INI_DIR/conf.d/
COPY ./etc/php/opcache.ini $PHP_INI_DIR/conf.d/
RUN pecl install xdebug
# We don't enable it here, so we can enable/disable on-the-fly in xdebug.ini
#RUN docker-php-ext-enable xdebug
