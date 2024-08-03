#!/bin/bash

# Prompt the user for passwords
read -sp "Enter MySQL root password: " MYSQL_ROOT_PASSWORD
echo
read -sp "Enter phpMyAdmin application password: " PHPMYADMIN_APP_PASSWORD
echo

# Update package list and install required packages
echo "0% - Installing packages..."
sudo apt-get update -q
sudo apt-get install -y -q apache2 curl subversion php8.1 php8.1-gd php8.1-zip libapache2-mod-php8.1 \
                        php8.1-curl php8.1-mysql php8.1-xmlrpc php-pear mariadb-server-10.6 \
                        php8.1-mbstring git php-bcmath

# Preconfigure phpMyAdmin settings
echo "20% - Configuring phpMyAdmin..."
sudo debconf-set-selections <<EOF
phpmyadmin phpmyadmin/app-password-confirm password $PHPMYADMIN_APP_PASSWORD
phpmyadmin phpmyadmin/mysql/admin-pass password $MYSQL_ROOT_PASSWORD
phpmyadmin phpmyadmin/password-confirm password $PHPMYADMIN_APP_PASSWORD
phpmyadmin phpmyadmin/mysql/app-pass password $PHPMYADMIN_APP_PASSWORD
phpmyadmin phpmyadmin/dbconfig-remove boolean true
phpmyadmin phpmyadmin/database-type select mysql
phpmyadmin phpmyadmin/missing-db-package-error select abort
phpmyadmin phpmyadmin/db/dbname string phpmyadmin
phpmyadmin phpmyadmin/upgrade-backup boolean true
phpmyadmin phpmyadmin/db/app-user string phpmyadmin@localhost
phpmyadmin phpmyadmin/upgrade-error select abort
phpmyadmin phpmyadmin/mysql/admin-user string root
phpmyadmin phpmyadmin/install-error select abort
phpmyadmin phpmyadmin/mysql/authplugin select default
phpmyadmin phpmyadmin/purge boolean false
phpmyadmin phpmyadmin/internal/reconfiguring boolean false
phpmyadmin phpmyadmin/dbconfig-install boolean true
phpmyadmin phpmyadmin/mysql/method select Unix socket
phpmyadmin phpmyadmin/dbconfig-upgrade boolean true
phpmyadmin phpmyadmin/dbconfig-reinstall boolean false
phpmyadmin phpmyadmin/remove-error select abort
phpmyadmin phpmyadmin/remote/host string localhost
phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2
phpmyadmin phpmyadmin/internal/skip-preseed boolean false
EOF

# Install phpMyAdmin non-interactively
echo "40% - Installing phpMyAdmin..."
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q phpmyadmin

# Modify MySQL configuration to allow remote connections
echo "50% - Configuring MySQL..."
sudo sed -i "s/^bind-address.*/bind-address=0.0.0.0/g" "/etc/mysql/mariadb.conf.d/50-server.cnf"
sudo systemctl restart mariadb

# Secure MySQL installation
echo "60% - Securing MySQL..."
sudo mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
EOF

# Download and install OpenGamePanel
echo "70% - Installing OpenGamePanel..."
wget -N "https://github.com/OpenGamePanel/Easy-Installers/raw/master/Linux/Debian-Ubuntu/ogp-panel-latest.deb" -O "ogp-panel-latest.deb" -q
sudo dpkg -i "ogp-panel-latest.deb"

# Install 32-bit libraries and other dependencies
echo "80% - Installing additional dependencies..."
sudo dpkg --add-architecture i386
sudo apt-get update -q
sudo apt-get install -y -q libstdc++6:i386
sudo apt-get install -y -q libxml-parser-perl libpath-class-perl perl-modules screen rsync sudo e2fsprogs unzip subversion libarchive-extract-perl pure-ftpd libarchive-zip-perl libc6 libgcc1 git curl
sudo apt-get install -y -q libc6-i386 libgcc1:i386 lib32gcc1 lib32gcc-s1 libhttp-daemon-perl

# Download and install OpenGamePanel agent
echo "90% - Installing OpenGamePanel agent..."
sudo wget -N "https://github.com/OpenGamePanel/Easy-Installers/raw/master/Linux/Debian-Ubuntu/ogp-agent-latest.deb" -O "ogp-agent-latest.deb" -q
sudo dpkg -i "ogp-agent-latest.deb"

# Update PHP configuration
echo "95% - Configuring PHP..."
sudo sed -i 's/^post_max_size = 8M/post_max_size = 900M/' /etc/php/8.1/apache2/php.ini
sudo sed -i 's/^upload_max_filesize = 2M/upload_max_filesize = 900M/' /etc/php/8.1/apache2/php.ini

# Configure Apache
echo "98% - Configuring Apache..."
sudo sed -i '$a Alias /phpmyadmin /usr/share/phpmyadmin' /etc/apache2/sites-available/000-default.conf

# Update system cache
echo "99% - Updating system cache..."
(crontab -l 2>/dev/null; echo "0 * * * * echo 3 > /proc/sys/vm/drop_caches") | crontab -

# Clone and configure themes
echo "100% - Finalizing configuration..."
cd /var/www/html/themes/
sudo git clone https://github.com/Reignsia/Obsidian -q
sudo mv Obsidian/themes/Obsidian/* Obsidian/
sudo rmdir Obsidian/themes/Obsidian

# Display OGP user password and panel MySQL info
sudo cat /root/ogp_user_password
sudo cat /root/ogp_panel_mysql_info

echo "Installation and configuration complete."
