#!/bin/bash

sudo apt-get update
sudo apt-get install -y apache2 curl subversion php7.4 php7.4-gd php7.4-zip libapache2-mod-php7.4 php7.4-curl php7.4-mysql php7.4-xmlrpc php-pear mariadb-server php7.4-mbstring git php-bcmath

sudo sed -i "s/^bind-address.*/bind-address=0.0.0.0/g" "/etc/mysql/mariadb.conf.d/50-server.cnf"

sudo apt-get install -y phpmyadmin

sudo wget -N "https://github.com/OpenGamePanel/Easy-Installers/raw/master/Linux/Debian-Ubuntu/ogp-panel-latest.deb" -O "ogp-panel-latest.deb"
sudo dpkg -i "ogp-panel-latest.deb"

sudo apt-get install -y libxml-parser-perl libpath-class-perl perl-modules screen rsync sudo e2fsprogs unzip subversion pure-ftpd libarchive-zip-perl libc6 libgcc1 git curl
sudo apt-get install -y libc6-i386
sudo apt-get install -y lib32gcc1
sudo apt-get install -y lib32gcc-s1
sudo apt-get install -y libhttp-daemon-perl
sudo apt-get install -y libarchive-extract-perl

sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install -y libstdc++6:i386

sudo wget -N "https://github.com/OpenGamePanel/Easy-Installers/raw/master/Linux/Debian-Ubuntu/ogp-agent-latest.deb" -O "ogp-agent-latest.deb"
sudo dpkg -i "ogp-agent-latest.deb"

sudo sed -i 's/^post_max_size = 8M/post_max_size = 900M/' /etc/php/7.4/apache2/php.ini
sudo sed -i 's/^upload_max_filesize = 2M/upload_max_filesize = 900M/' /etc/php/7.4/apache2/php.ini

sudo sed -i '$a Alias /phpmyadmin /usr/share/phpmyadmin' /etc/apache2/sites-available/000-default.conf

(crontab -l 2>/dev/null; echo "0 * * * * echo 3 > /proc/sys/vm/drop_caches") | crontab -

cd /var/www/html/themes/
sudo git clone https://github.com/Reignsia/Obsidian
sudo mv Obsidian/themes/Obsidian/* Obsidian/
sudo rmdir Obsidian/themes/Obsidian

sudo mysql_secure_installation

sudo systemctl restart apache2
sudo systemctl enable apache2
sudo systemctl enable ogp_agent
sudo systemctl enable mariadb
sudo systemctl enable mysql

sudo apt-get update
sudo apt-get install -y fail2ban

sudo tee /etc/fail2ban/filter.d/udp-flood.conf > /dev/null <<'EOF'
[Definition]
failregex = .*SRC=<HOST> .*DPT=<port>.*UDP.*
ignoreregex =
EOF

sudo tee -a /etc/fail2ban/jail.local > /dev/null <<'EOF'
[udp-flood]
enabled = true
filter = udp-flood
action = iptables[name=UDP, port=<port>, protocol=udp]
logpath = /var/log/syslog
maxretry = 10
bantime = 3600
findtime = 600
EOF

sudo systemctl restart fail2ban

echo "Fail2Ban setup complete for UDP flood protection."

sudo apt update
sudo apt install ufw
sudo ufw enable
sudo ufw allow proto tcp from any to any
sudo ufw allow proto udp from any to any

sudo cat /root/ogp_user_password
sudo cat /root/ogp_panel_mysql_info
