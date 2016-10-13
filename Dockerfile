FROM xetusoss/ossec-server:2.8.2
MAINTAINER Fabrizio Galiano <fabrizio.galiano@mosaicoon.com>

# Ossec Server with WebUi

ENV APP_CWD='/app/code' \
APP_USER='application' \
APP_GROUP='application' \
VHOST_ROOT='/app/code' \
VHOST_INDEX='index.php' \
VHOST_TRYFILES='try_files $uri $uri/ /index.php?$query_string;' \
PHP_MAXEXECUTIONTIME='30' \
PHP_MEMORYLIMIT='128M' \
PHP_DISPLAYERRORS='Off' \
PHP_DISPLASTARTUPERRORS='Off' \
PHP_ERRORREPORTING='E_ALL & ~E_DEPRECATED & ~E_STRICT' \
PHP_VARIABLESORDER='GPCS' \
PHP_POSTMAXSIZE='8M' \
PHP_UPLOADMAXFILESIZE='2M' \
PHP_SHORTOPENTAG='Off' \
PHP_MODULESPATH='/usr/lib/php/20151012' \
FPM_USER='application' \
FPM_GROUP='application' \
FPM_LISTEN='127.0.0.1:9000' \
FPM_CLEARENV='no'

RUN apt-get update
RUN apt-get install -y sudo software-properties-common curl git wget
RUN apt-add-repository ppa:ondrej/php -y
RUN apt-get update

RUN apt-get install -y --allow-unauthenticated php-cli php-dev php-pear \
php-mysql php-pgsql php-sqlite3 \
php-apcu php-json php-curl php-gd \
php-gmp php-imap php-mcrypt php-xdebug \
php-memcached php-redis php-mbstring php-zip \
pkg-config libssl-dev libsslcommon2-dev

RUN apt-get install -y --allow-unauthenticated nginx php-fpm

#install composer
RUN wget https://getcomposer.org/composer.phar -O /usr/bin/composer && chmod +x /usr/bin/composer

#install supervisord
RUN apt-get install -y supervisor

#
# Initialize the data volume configuration
#
ADD scripts/ossec-data_dirs.env /docker/scripts/ossec-data_dirs.env
ADD scripts/ossec-init.sh /docker/scripts/ossec-init.sh
# Sync calls are due to https://github.com/docker/docker/issues/9547
RUN chmod 755 /docker/scripts/ossec-init.sh &&\
  sync && /docker/scripts/ossec-init.sh &&\
  sync && rm /docker/scripts/ossec-init.sh


#RUN mkdir /usr/lib/php/modules && \
#RUN mv /usr/sbin/php-fpm7 /usr/sbin/php-fpm && mv /usr/bin/php7 /usr/bin/php


#Add configuration files
COPY . /docker

#expose ports
EXPOSE 80 443 

ENTRYPOINT ["bash", "/docker/scripts/entrypoint.sh"]
CMD ["start-stack"]

WORKDIR $APP_CWD
