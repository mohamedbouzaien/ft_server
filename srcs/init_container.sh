# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    init_container.sh                                  :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mbouzaie <mbouzaie@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/06/09 02:05:25 by mbouzaie          #+#    #+#              #
#    Updated: 2020/06/14 16:26:15 by mbouzaie         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

pwd;

#Configure NGINX
mv /tmp/monblog-nginx.conf /etc/nginx/sites-available/monblog.tn
ln -s /etc/nginx/sites-available/monblog.tn /etc/nginx/sites-enabled/monblog.tn
rm -f /etc/nginx/sites-enabled/default

#Configure PHPMYADMIN
cd /var/www/ && mkdir monblog.tn && mkdir monblog.tn/phpmyadmin
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.5/phpMyAdmin-4.9.5-all-languages.tar.gz
tar -xvf phpMyAdmin-4.9.5-all-languages.tar.gz --strip-components 1 -C monblog.tn/phpmyadmin
rm -f phpMyAdmin-4.9.5-all-languages.tar.gz
cp /tmp/config.inc.php monblog.tn/phpmyadmin/

#Configure SSL
openssl req -x509 -nodes -days 365 -subj "/C=CA/ST=QC/O=Company, Inc./CN=monblog.tn" -addext "subjectAltName=DNS:monblog.tn" -newkey rsa:2048 -keyout /etc/ssl/private/nginx-monblog.key -out /etc/ssl/certs/nginx-monblog.crt

#Start NGINX
service nginx start

#Start MYSQL
service mysql start

#Start PHP-FPM
service php7.3-fpm start

#Create websites folder and copy wordpress files
mv /usr/share/wordpress/ monblog.tn/
mv /tmp/wp-config.php monblog.tn/wordpress/

#Config MYSQL
echo "CREATE DATABASE wordpress;" | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT \
	OPTION;" | mysql -u root --skip-password
echo "UPDATE mysql.user SET plugin='mysql_native_password' WHERE user='root';" | mysql -u root --skip-password
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password

#Create aliases to disable and enable autoindex
echo "alias autoindex_off=\"sed -i 's/autoindex on/autoindex off/g' /etc/nginx/sites-available/monblog.tn; service nginx restart\"" >> ~/.bashrc; 
echo "alias autoindex_on=\"sed -i 's/autoindex off/autoindex on/g' /etc/nginx/sites-available/monblog.tn; service nginx restart\"" >> ~/.bashrc;

# Go to the containers bash for that the machine stays running
bash
