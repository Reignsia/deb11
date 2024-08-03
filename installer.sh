#!/bin/bash

echo "[1/5] Installing Dependencies..."
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

