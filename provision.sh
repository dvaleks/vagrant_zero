#!/usr/bin/env bash

# @dv: ensure that /vagrant is linked to /var/www
if ! [ -L /var/www ]; then
	rm -rf /var/www
  	ln -fs /vagrant /var/www
fi

apt-get update
apt-get install -y \
	nginx \
	php-fpm \
	mysql-server \
	php-mysqli

# @dv: copy server block configuration file, establish link
cp /vagrant/my_configs/valeks.com /etc/nginx/sites-available/valeks.com
ln -s /etc/nginx/sites-available/valeks.com /etc/nginx/sites-enabled/
unlink /etc/nginx/sites-enabled/default

# @dv: security issue: to prevent arbitrarily script injection
echo "cgi.fix_pathinfo=0" >> /etc/php/7.2/fpm/php.ini

systemctl reload nginx

# @dv: restore database from dump
mysql -e "CREATE DATABASE siteDB;"
mysql siteDB < /vagrant/my_configs/dump.sql

# @dv: create a user with privileges to connect to db via mysqli
mysql -e "USE mysql;"
mysql -e "CREATE user 'site_root'@'localhost' IDENTIFIED BY '';"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'site_root'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"
service mysql restart