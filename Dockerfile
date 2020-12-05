FROM debian:buster

# open port 80 for lanching php laravel api
# open port 8080 for lanching nginx to run phpMyAdmin
# open port 3306 for lanching mysql
# open port 3000 for lanching react frontend
EXPOSE 80 8080 443 3306 3000

# install dpendencies packages
RUN	apt-get update	&& 			\
	apt-get install -y nginx	\
	php7.3-fpm php7.3-mysql		\
	php7.3-xml php7.3-mbstring	\
	wget dpkg lsb-release gnupg	\
	unzip vim curl	&&			\
	rm -rf /var/www/html/*


# RUN apt-get install -y wget dpkg lsb-release gnupg unzip vim curl
# RUN rm -rf /var/www/html/*

# copy the default file for nginx to make nginx
# work in 8080 and use php fast CGI
COPY srcs/nginx/default /etc/nginx/sites-enabled

# copy the default file for php7.3-fpm
# to enable mysqli extention and others
COPY srcs/phpMyAdmin/php.ini /etc/php/7.3/fpm/


# copy sql file to create phpmyadmib database and all tables
COPY srcs/phpMyAdmin/create_phpmy_admin_db.sql /root/

# copy phpMyAdmin code source to use it
COPY srcs/phpMyAdmin/phpMyAdmin.zip /var/www/html/

# copy the script that will install mysql
COPY srcs/sh/install_mysql.sh /root/

# copy a script that will add to the root mysql user a password
# and also create a pma user
COPY srcs/sh/init.sh /root/

# copy a script that will start nginx, php7.3-fpm and mysql
COPY srcs/sh/run.sh /root/

# unzip phpMyAdmin code source to get the phpMyAdmin Folder
# run mysql script the install it
# run init.sh to create pma user and set mysql root a password
# install composer
# install laravel
RUN unzip /var/www/html/phpMyAdmin.zip -d /var/www/html/ && rm -rf /var/www/html/phpMyAdmin.zip						&& \
	/bin/bash /root/install_mysql.sh && /bin/rm -rf /root/install_mysql.sh											&& \
	/bin/bash /root/init.sh && /bin/rm -rf /root/init.sh															&& \
	/bin/rm -rf /root/create_phpmy_admin_db.sql																		&& \
	wget https://getcomposer.org/installer && php installer	&& rm -rf installer && mv composer.phar /bin/composer	&& \
	composer global require laravel/installer

# copy config file pf phpMyAdmin to user pma user
# and also use phpmyadmin database
COPY srcs/phpMyAdmin/config.inc.php /var/www/html/phpMyAdmin/


# CMD sh /root/run.sh
