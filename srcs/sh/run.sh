#!/bin/bash
# chown -R mysql: /var/lib/mysql
service php7.3-fpm start
service mysql start
service nginx start
