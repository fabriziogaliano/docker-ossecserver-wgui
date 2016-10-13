#/bin/bash

apt-get update;

# Basic packages
apt-get install -y sudo software-properties-common nano curl git;

# PPA
apt-add-repository ppa:ondrej/php -y;

# Update Package Lists
apt-get update;

# Create homestead user
#adduser homestead
#usermod -p $(echo secret | openssl passwd -1 -stdin) homestead
# Add homestead to the sudo group and www-data
#usermod -aG sudo homestead
#usermod -aG www-data homestead

# Timezone
#ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# PHP
apt-get install -y --allow-unauthenticated php-cli php-dev php-pear \
php-mysql php-pgsql php-sqlite3 \
php-apcu php-json php-curl php-gd \
php-gmp php-imap php-mcrypt php-xdebug \
php-memcached php-redis php-mbstring php-zip;

# Nginx & PHP-FPM
apt-get install -y --allow-unauthenticated nginx php-fpm;

# Enable mcrypt
#phpenmod mcrypt --allow-unauthenticated
