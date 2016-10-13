#!/bin/env bash
# $Id: bootloader.sh,v 0.1 2016/04/10 $ $Author: Pietro Bonaccorso $

#create group if not exists
if grep -q $APP_GROUP /etc/group
then
    echo "group $APP_GROUP already exists"
else
    useradd $APP_GROUP --disabled-password
fi

if grep -q $APP_USER /etc/passwd
then
    echo "user $APP_USER already exists"
else
    useradd $APP_USER -s /bin/bash
    usermod -aG $APP_GROUP $APP_USER
fi

# Move site for Ossec WGUI
mv /docker/ossec-wgui/* /app/code/
chmod 777 /var/ossec/ -R

#create application user if not exists and assig it to the specified application group
#id -u $APP_USER &>/dev/null || adduser -D -s /bin/bash $APP_USER $APP_GROUP

#adduser application --disabled-password

#create application folder if not exists
if ! [[ -d $APP_CWD ]] ; then mkdir -p $APP_CWD ; fi

#assign user and group permission to application folder
chown $APP_USER:$APP_GROUP $APP_CWD

#add vhost configuration template
cp /docker/configuration/nginx/default.conf /etc/nginx/sites-available/default

#add php configuration template
cp /docker/configuration/php/php.ini /etc/php/7.0/cli/php.ini
cp /docker/configuration/php/php.ini /etc/php/7.0/fpm/php.ini

#add php-fpm configuration template
cp /docker/configuration/php-fpm/php-fpm.conf /etc/php/7.0/fpm/pool.d/www.conf
cp /docker/configuration/php-fpm/php-fpm.conf /etc/php/7.0/fpm/php-fpm.conf

for var in $(printenv); do

    #explode vars to retrive key/value pairs
    IFS='=' read -r -a array <<< $var

    export KEY=${array[0]}

    if [[ $KEY =~ VHOST_|PHP_|FPM_ ]]; then

        export VALUE=${array[1]}

        sed -i -e 's|<'$KEY'>|'$VALUE'|g' '/etc/nginx/sites-available/default'
        sed -i -e 's|<'$KEY'>|'$VALUE'|g' '/etc/php/7.0/cli/php.ini'
        sed -i -e 's|<'$KEY'>|'$VALUE'|g' '/etc/php/7.0/fpm/php.ini'
        sed -i -e 's|<'$KEY'>|'$VALUE'|g' '/etc/php/7.0/fpm/pool.d/www.conf'
        sed -i -e 's|<'$KEY'>|'$VALUE'|g' '/etc/php/7.0/fpm/php-fpm.conf'

    fi

done
