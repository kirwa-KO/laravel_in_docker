#!/bin/bash
chown -R mysql: /var/lib/mysql
service mysql start

mysql -u root < /root/create_phpmy_admin_db.sql
mysql -u root -e "CREATE USER 'pma'@localhost IDENTIFIED BY 'kirwa-KO';"
mysql -u root -e "GRANT ALL PRIVILEGES ON phpmyadmin.* TO 'pma'@'localhost';"
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'toor';FLUSH PRIVILEGES;"

echo "set number" > ~/.vimrc
echo "syntax on" > ~/.vimrc
echo "export PATH=/root/.composer/vendor/laravel/installer/bin:$PATH" > ~/.bashrc
source ~/.bashrc

if [ ! -d '/var/www/html/phpMyAdmin/tmp' ]
then
	mkdir /var/www/html/phpMyAdmin/tmp
fi

# because this should be accesible by
chmod 777 /var/www/html/phpMyAdmin/tmp