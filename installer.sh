#!/bin/bash

echo "What to install?"
echo "[0] Both"
echo "[1] Agent"
read -p "Input: " choice

case $choice in
    0)
    
echo "[1/10] Installing dependencies..."
sudo apt-get update -qq
sudo apt-get upgrade -y -qq
sudo dpkg --add-architecture i386
sudo apt-get update -qq
sudo apt-get install -y -qq libstdc++6:i386
sudo apt-get install -y -qq libxml-parser-perl libpath-class-perl perl-modules screen rsync sudo e2fsprogs unzip subversion libarchive-extract-perl pure-ftpd libarchive-zip-perl libc6 libgcc1 git curl
sudo apt-get install -y -qq libc6-i386
sudo apt-get install -y -qq libgcc1:i386
sudo apt-get install -y -qq lib32gcc-s1
sudo apt-get install -y -qq libhttp-daemon-perl
sudo apt-get install -y -qq apache2 curl subversion php8.1 php8.1-gd php8.1-zip libapache2-mod-php8.1 php8.1-curl php8.1-mysql php8.1-xmlrpc php-pear mariadb-server-10.6 php8.1-mbstring git php-bcmath

echo "[2/10] Installing MySQL..."
sudo mysql_secure_installation

echo "[3/10] Installing PhpMyAdmin..."
sudo apt-get install -y -qq phpmyadmin

echo "[4/10] Installing panel..."
wget -N -q "https://github.com/OpenGamePanel/Easy-Installers/raw/master/Linux/Debian-Ubuntu/ogp-panel-latest.deb" -O "ogp-panel-latest.deb"
sudo dpkg -i "ogp-panel-latest.deb"

echo "[5/10] Installing OGP Agent..."
wget -N -q "https://github.com/OpenGamePanel/Easy-Installers/raw/master/Linux/Debian-Ubuntu/ogp-agent-latest.deb" -O "ogp-agent-latest.deb"
sudo dpkg -i "ogp-agent-latest.deb"

echo "[6/10] Configuring..."
sudo sed -i "s/^bind-address.*/bind-address=0.0.0.0/g" "/etc/mysql/mariadb.conf.d/50-server.cnf"
sudo sed -i 's/^post_max_size = 8M/post_max_size = 900M/' /etc/php/8.1/apache2/php.ini
sudo sed -i 's/^upload_max_filesize = 2M/upload_max_filesize = 900M/' /etc/php/8.1/apache2/php.ini
sudo sed -i '$a Alias /phpmyadmin /usr/share/phpmyadmin' /etc/apache2/sites-available/000-default.conf
(crontab -l 2>/dev/null; echo "0 * * * * echo 3 > /proc/sys/vm/drop_caches") | crontab -

echo "[7/10] Installing theme..."
sudo apt-get install -y -qq git
cd /var/www/html/themes/
sudo git clone https://github.com/Reignsia/Obsidian
sudo mv Obsidian/themes/Obsidian/* Obsidian/
sudo rmdir Obsidian/themes/Obsidian

echo "[8/10] Opening all ports..."
sudo iptables -A INPUT -p tcp -j ACCEPT && sudo iptables -A INPUT -p udp -j ACCEPT && sudo iptables -A OUTPUT -p tcp -j ACCEPT && sudo iptables -A OUTPUT -p udp -j ACCEPT
sudo iptables-save | sudo tee /etc/iptables/rules.v4

echo "[9/10] Enabling all systemd..."
sudo systemctl restart apache2
sudo systemctl enable apache2
sudo systemctl enable ogp_agent
sudo systemctl enable mariadb
sudo systemctl enable mysql

echo "[10/10] Successful Installation"
sudo cat /root/ogp_user_password
sudo cat /root/ogp_panel_mysql_info

;;
    1)

sudo apt-get update -qq
sudo apt-get upgrade -y -qq
sudo dpkg --add-architecture i386 
sudo apt-get update -qq
sudo apt-get install -y -qq libstdc++6:i386
sudo apt-get install -y -qq libxml-parser-perl libpath-class-perl perl-modules screen rsync sudo e2fsprogs unzip subversion libarchive-extract-perl pure-ftpd libarchive-zip-perl libc6 libgcc1 git curl
sudo apt-get install -y -qq libc6-i386
sudo apt-get install -y -qq libgcc1:i386
sudo apt-get install -y -qq lib32gcc1
sudo apt-get install -y -qq lib32gcc-s1
sudo apt-get install -y -qq libhttp-daemon-perl
echo "[1/2] Installing dependencies..."
wget -N -q "https://github.com/OpenGamePanel/Easy-Installers/raw/master/Linux/Debian-Ubuntu/ogp-agent-latest.deb" -O "ogp-agent-latest.deb"
sudo dpkg -i "ogp-agent-latest.deb" > /dev/null 2>&1
echo "[2/2] Done"
sudo cat /root/ogp_user_password

;;
    *)
    esac
