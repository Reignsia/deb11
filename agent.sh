sudo apt-get install -y libxml-parser-perl libpath-class-perl perl-modules screen rsync sudo e2fsprogs unzip subversion pure-ftpd libarchive-zip-perl libc6 libgcc1 git curl
sudo apt-get install -y libc6-i386
sudo apt-get install -y lib32gcc1
sudo apt-get install -y lib32gcc-s1
sudo apt-get install -y libhttp-daemon-perl
sudo apt-get install -y libarchive-extract-perl
sudo apt-get install iptables
sudo apt-get install iptables-persistent

sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install -y libstdc++6:i386

sudo wget -N "https://github.com/OpenGamePanel/Easy-Installers/raw/master/Linux/Debian-Ubuntu/ogp-agent-latest.deb" -O "ogp-agent-latest.deb"
sudo dpkg -i "ogp-agent-latest.deb"

(crontab -l 2>/dev/null; echo "0 * * * * echo 3 > /proc/sys/vm/drop_caches") | crontab -

sudo iptables -A INPUT -p tcp --dport 1:65535 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 1:65535 -j ACCEPT
sudo iptables -A OUTPUT -p tcp --dport 1:65535 -j ACCEPT
sudo iptables -A OUTPUT -p udp --dport 1:65535 -j ACCEPT

sudo iptables-save > /etc/iptables/rules.v4

sudo cat /root/ogp_user_password
