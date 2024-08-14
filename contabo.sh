#!/bin/bash

apt-get update
apt-get install -y apache2 curl subversion php7.4 php7.4-gd php7.4-zip libapache2-mod-php7.4 php7.4-curl php7.4-mysql php7.4-xmlrpc php-pear mariadb-server php7.4-mbstring git php-bcmath

sed -i "s/^bind-address.*/bind-address=0.0.0.0/g" "/etc/mysql/mariadb.conf.d/50-server.cnf"

apt-get install -y phpmyadmin

wget -N "https://github.com/OpenGamePanel/Easy-Installers/raw/master/Linux/Debian-Ubuntu/ogp-panel-latest.deb" -O "ogp-panel-latest.deb"
dpkg -i "ogp-panel-latest.deb"

apt-get install -y libxml-parser-perl libpath-class-perl perl-modules screen rsync e2fsprogs unzip subversion pure-ftpd libarchive-zip-perl libc6 libgcc1 git curl
apt-get install -y libc6-i386
apt-get install -y lib32gcc1
apt-get install -y lib32gcc-s1
apt-get install -y libhttp-daemon-perl
apt-get install -y libarchive-extract-perl

dpkg --add-architecture i386
apt-get update
apt-get install -y libstdc++6:i386

wget -N "https://github.com/OpenGamePanel/Easy-Installers/raw/master/Linux/Debian-Ubuntu/ogp-agent-latest.deb" -O "ogp-agent-latest.deb"
dpkg -i "ogp-agent-latest.deb"

sed -i 's/^post_max_size = 8M/post_max_size = 900M/' /etc/php/7.4/apache2/php.ini
sed -i 's/^upload_max_filesize = 2M/upload_max_filesize = 900M/' /etc/php/7.4/apache2/php.ini

sed -i '$a Alias /phpmyadmin /usr/share/phpmyadmin' /etc/apache2/sites-available/000-default.conf

(crontab -l 2>/dev/null; echo "0 * * * * echo 3 > /proc/sys/vm/drop_caches") | crontab -

cd /var/www/html/themes/
git clone https://github.com/Reignsia/Obsidian
mv Obsidian/themes/Obsidian/* Obsidian/
rmdir Obsidian/themes/Obsidian

mysql_secure_installation

systemctl restart apache2
systemctl enable apache2
systemctl enable ogp_agent
systemctl enable mariadb
systemctl enable mysql

apt update
apt install ufw
ufw enable
ufw allow proto tcp from any to any
ufw allow proto udp from any to any

cat /root/ogp_user_password
cat /root/ogp_panel_mysql_info
