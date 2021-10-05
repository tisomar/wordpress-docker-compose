FROM wordpress:5.6.2-php7.3-apache

WORKDIR /var/www/html

RUN apt-get update \
    &&  apt-get -y install tzdata cron \
    && a2enmod rewrite \
    && apt-get install -y --no-install-recommends libpq-dev libicu-dev libzip-dev zip unzip git \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pgsql pdo pdo_pgsql \
    && pecl install apcu xdebug \
    && docker-php-ext-enable apcu xdebug \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt update \
	&& apt -y install vim

# Configurando o timezone do servidor
RUN ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

#RUN apt-get -y remove tzdata
RUN rm -rf /var/cache/apk/*

# Apache settings
COPY ./config/php.conf.ini /usr/local/etc/php/conf.d/php.ini

COPY wordpress/ /var/www/html/

RUN chmod 777 -R /var/www/html/
EXPOSE 80
CMD [ "sh", "-c", "cron -f" ]