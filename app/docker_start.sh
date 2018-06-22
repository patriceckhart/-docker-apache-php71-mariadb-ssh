#!/bin/bash

rm /var/run/apache2/*
rm /var/run/mysqld/*
rm /var/run/crond.pid

chown -R www-data:www-data /var/www/
chmod -R 775 /var/www/

service apache2 start
service apache2 status

if hash composer; then
  echo "Composer Already Installed"
  echo "You can find it at $(type -p composer)"
  exit
fi

wget https://getcomposer.org/composer.phar
mv composer.phar /bin/composer

echo "Composer Installed Globally Successfully"
echo "Composer Installed at $(type -p composer)"
echo "You can always find it by calling `type -p composer`"

chsh -s /bin/bash www-data
echo "www-data:www" | chpasswd

echo "max_execution_time=240" >> /etc/php/7.1/apache2/php.ini
echo "max_input_vars=1500" >> /etc/php/7.1/apache2/php.ini

mkdir /var/log/supervisor

/usr/bin/supervisord

a2enmod rewrite

service apache2 reload