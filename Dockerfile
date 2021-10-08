FROM wordpress:php7.1-apache
WORKDIR /var/www/html

# Habilitando o modo de reescrita do Apache
RUN a2enmod rewrite

RUN mkdir -p /etc/php/7.1/mods-available/

# Install selected extensions and other stuff
RUN apt-get update \
    && apt-get -y --no-install-recommends install  php-xdebug \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \
    && pecl install xdebug-2.5.0 \
    && docker-php-ext-enable xdebug

COPY ./wordpress /var/www/html
COPY ./config/php.ini /usr/local/etc/php/php.ini
RUN chown -R www-data /var/www/html
EXPOSE 80
