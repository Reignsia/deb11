
#!/bin/bash

echo "[1/10] Installing dependencies..."
sudo apt-get update -qq > /dev/null 2>&1
sudo apt-get upgrade -y -qq > /dev/null 2>&1
sudo dpkg --add-architecture i386 > /dev/null 2>&1
sudo apt-get update -qq > /dev/null 2>&1
sudo apt-get install -y -qq libstdc++6:i386 > /dev/null 2>&1
sudo apt-get install -y -qq libxml-parser-perl libpath-class-perl perl-modules screen rsync sudo e2fsprogs unzip subversion libarchive-extract-perl pure-ftpd libarchive-zip-perl libc6 libgcc1 git curl > /dev/null 2>&1
sudo apt-get install -y -qq libc6-i386 > /dev/null 2>&1
sudo apt-get install -y -qq libgcc1:i386 > /dev/null 2>&1
sudo apt-get install -y -qq lib32gcc1 > /dev/null 2>&1
sudo apt-get install -y -qq lib32gcc-s1 > /dev/null 2>&1
sudo apt-get install -y -qq libhttp-daemon-perl > /dev/null 2>&1
sudo apt-get install -y -qq apache2 curl subversion php8.1 php8.1-gd php8.1-zip libapache2-mod-php8.1 php8.1-curl php8.1-mysql php8.1-xmlrpc php-pear mariadb-server-10.6 php8.1-mbstring git php-bcmath > /dev/null 2>&1

echo "[2/10] Installing MySQL..."
sudo mysql_secure_installation

echo "[3/10] Installing PhpMyAdmin..."
sudo apt-get install - qq phpmyadmin > /dev/null 2>&1

echo "[4/10] Installing panel..."
wget -N -q "https://github.com/OpenGamePanel/Easy-Installers/raw/master/Linux/Debian-Ubuntu/ogp-panel-latest.deb" -O "ogp-panel-latest.deb"
sudo dpkg -i "ogp-panel-latest.deb" > /dev/null 2>&1

echo "[5/10] Installing OGP Agent..."
wget -N -q "https://github.com/OpenGamePanel/Easy-Installers/raw/master/Linux/Debian-Ubuntu/ogp-agent-latest.deb" -O "ogp-agent-latest.deb"
sudo dpkg -i "ogp-agent-latest.deb" > /dev/null 2>&1

echo "[6/10] Configuring..."
sudo sed -i "s/^bind-address.*/bind-address=0.0.0.0/g" "/etc/mysql/mariadb.conf.d/50-server.cnf" > /dev/null 2>&1
sudo sed -i 's/^post_max_size = 8M/post_max_size = 900M/' /etc/php/8.1/apache2/php.ini > /dev/null 2>&1
sudo sed -i 's/^upload_max_filesize = 2M/upload_max_filesize = 900M/' /etc/php/8.1/apache2/php.ini > /dev/null 2>&1
sudo sed -i '$a Alias /phpmyadmin /usr/share/phpmyadmin' /etc/apache2/sites-available/000-default.conf > /dev/null 2>&1
(crontab -l 2>/dev/null; echo "0 * * * * echo 3 > /proc/sys/vm/drop_caches") | crontab - > /dev/null 2>&1

echo "[7/10] Installing theme..."
