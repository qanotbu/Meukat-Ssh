#!/bin/sh

# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
#MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0'`;
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";
#ether=`ifconfig | cut -c 1-8 | sort | uniq -u | grep venet0 | grep -v venet0:`
#if [ "$ether" = "" ]; then
#        ether=eth0
#fi

#MYIP=$(ifconfig | grep 'inet addr:' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d: -f2 | awk '{ print $1}' | head -1)
#if [ "$MYIP" = "" ]; then
#		MYIP=$(wget -qO- ipv4.icanhazip.com)
#fi
#MYIP2="s/xxxxxxxxx/$MYIP/g";

# go to root
cd

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# install wget and curl
apt-get update;apt-get -y install wget curl;

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

# set repo
wget -O /etc/apt/sources.list "https://github.com/radhsyn83/debian7/raw/master/sources.list.debian7"
wget "http://www.dotdeb.org/dotdeb.gpg"
wget "http://www.webmin.com/jcameron-key.asc"
cat dotdeb.gpg | apt-key add -;rm dotdeb.gpg
cat jcameron-key.asc | apt-key add -;rm jcameron-key.asc

# remove unused
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove sendmail*;
apt-get -y --purge remove bind9*;

# update
apt-get update; apt-get -y upgrade;

# install webserver
apt-get -y install nginx php5-fpm php5-cli

# install essential package
echo "mrtg mrtg/conf_mods boolean true" | debconf-set-selections
#apt-get -y install bmon iftop htop nmap axel nano iptables traceroute sysv-rc-conf dnsutils bc nethogs openvpn vnstat less screen psmisc apt-file whois ptunnel ngrep mtr git zsh mrtg snmp snmpd snmp-mibs-downloader unzip unrar rsyslog debsums rkhunter
apt-get -y install bmon iftop htop nmap axel nano iptables traceroute sysv-rc-conf dnsutils bc nethogs vnstat less screen psmisc apt-file whois ptunnel ngrep mtr git zsh mrtg snmp snmpd snmp-mibs-downloader unzip unrar rsyslog debsums rkhunter
apt-get -y install build-essential

# disable exim
service exim4 stop
sysv-rc-conf exim4 off

# update apt-file
apt-file update

# setting vnstat
vnstat -u -i venet0
service vnstat restart

# install screenfetch
cd
wget 'https://github.com/radhsyn83/debian7/raw/master/screenfetch-dev'
mv screenfetch-dev /usr/bin/screenfetch-dev
chmod +x /usr/bin/screenfetch-dev
echo "clear" >> .profile
echo "screenfetch-dev" >> .profile

# install webserver
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://github.com/radhsyn83/debian7/raw/master/nginx.conf"
mkdir -p /home/vps/public_html
echo "<pre>Edited by Radh_syn</pre>" > /home/vps/public_html/index.html
echo "<?php phpinfo(); ?>" > /home/vps/public_html/info.php
wget -O /etc/nginx/conf.d/vps.conf "https://github.com/radhsyn83/debian7/raw/master/vps.conf"
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf
service php5-fpm restart
service nginx restart

# install openvpn
#wget -O /etc/openvpn/openvpn.tar "https://www.dropbox.com/s/1bgtsp34vpb4psq/openvpn-debian.tar"
#cd /etc/openvpn/
#tar xf openvpn.tar
#wget -O /etc/openvpn/1194.conf "https://github.com/radhsyn83/debian7/raw/master/1194.conf"
#service openvpn restart
#sysctl -w net.ipv4.ip_forward=1
#sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
#wget -O /etc/iptables.up.rules "https://github.com/radhsyn83/debian7/raw/master/iptables.up.rules"
#sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.local
#sed -i $MYIP2 /etc/iptables.up.rules;
#iptables-restore < /etc/iptables.up.rules
#service openvpn restart

# configure openvpn client config
#cd /etc/openvpn/
#wget -O /etc/openvpn/1194-client.ovpn "https://github.com/radhsyn83/debian7/raw/master/1194-client.conf"
#sed -i $MYIP2 /etc/openvpn/1194-client.ovpn;
PASS=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1`;
useradd -M -s /bin/false ignore
echo "sense324:$PASS" | chpasswd
#echo "username" >> pass.txt
#echo "password" >> pass.txt
#tar cf client.tar 1194-client.ovpn pass.txt
#cp client.tar /home/vps/public_html/
#cp 1194-client.ovpn client.ovpn
#cp client.ovpn /home/vps/public_html/
cd

# install badvpn
wget -O /usr/bin/badvpn-udpgw "https://www.dropbox.com/s/hh1gviri22y070t/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw "https://www.dropbox.com/s/pu3kbk2nv4c5h5l/badvpn-udpgw64"
fi
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300


# install mrtg
wget -O /etc/snmp/snmpd.conf "https://github.com/radhsyn83/debian7/raw/master/snmpd.conf"
wget -O /root/mrtg-mem.sh "https://github.com/radhsyn83/debian7/raw/master/mrtg-mem.sh"
chmod +x /root/mrtg-mem.sh
cd /etc/snmp/
sed -i 's/TRAPDRUN=no/TRAPDRUN=yes/g' /etc/default/snmpd
service snmpd restart
snmpwalk -v 1 -c public localhost 1.3.6.1.4.1.2021.10.1.3.1
mkdir -p /home/vps/public_html/mrtg
cfgmaker --zero-speed 100000000 --global 'WorkDir: /home/vps/public_html/mrtg' --output /etc/mrtg.cfg public@localhost
curl "https://github.com/radhsyn83/debian7/raw/master/mrtg.conf" >> /etc/mrtg.cfg
sed -i 's/WorkDir: \/var\/www\/mrtg/# WorkDir: \/var\/www\/mrtg/g' /etc/mrtg.cfg
sed -i 's/# Options\[_\]: growright, bits/Options\[_\]: growright/g' /etc/mrtg.cfg
indexmaker --output=/home/vps/public_html/mrtg/index.html /etc/mrtg.cfg
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
cd

# setting port ssh
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
#sed -i '/Port 22/a Port 80' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
sed -i 's/#Banner/Banner/g' /etc/ssh/sshd_config
service ssh restart

# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=443/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 443 -p 110 -p 109"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
service ssh restart
service dropbear restart

# upgrade dropbear 2014
#apt-get install zlib1g-dev
#wget https://www.dropbox.com/s/qa89knc2m1lfh7x/dropbear-2014.63.tar.bz2
#bzip2 -cd dropbear-2014.63.tar.bz2  | tar xvf -
#cd dropbear-2014.63
#./configure
#make && make install
#mv /usr/sbin/dropbear /usr/sbin/dropbear1
#ln /usr/local/sbin/dropbear /usr/sbin/dropbear
#service dropbear restart

# install vnstat gui
cd /home/vps/public_html/
wget https://www.dropbox.com/s/g0yyci24w91s5ba/vnstat_php_frontend-1.5.1.tar.gz
tar xf vnstat_php_frontend-1.5.1.tar.gz
rm vnstat_php_frontend-1.5.1.tar.gz
mv vnstat_php_frontend-1.5.1 vnstat
cd vnstat
sed -i 's/eth0/venet0/g' config.php
sed -i "s/\$iface_list = array('venet0', 'sixxs');/\$iface_list = array('venet0');/g" config.php
sed -i "s/\$language = 'nl';/\$language = 'en';/g" config.php
sed -i 's/Internal/Internet/g' config.php
sed -i '/SixXS IPv6/d' config.php
cd

# install fail2ban
apt-get -y install fail2ban;service fail2ban restart

# install nano
apt-get -y install nano

# install squid3
apt-get -y install squid3
wget -O /etc/squid3/squid.conf "https://github.com/radhsyn83/debian7/raw/master/squid3.conf"
sed -i $MYIP2 /etc/squid3/squid.conf;
service squid3 restart

# install webmin
cd
#wget https://www.dropbox.com/s/9vbc213hm4lnlkc/webmin_1.690_all.deb
wget -O webmin-current.deb "http://www.webmin.com/download/deb/webmin-current.deb"
dpkg -i --force-all webmin-current.deb;
apt-get -y -f install;
rm /root/webmin-current.deb
service webmin restart
service vnstat restart

# install pptp vpn
#wget https://github.com/radhsyn83/debian7/raw/master/pptpinstall.sh
#chmod +x pptpinstall.sh
#./pptpinstall.sh

# download script
cd /usr/bin/
wget -O trial "https://github.com/radhsyn83/debian7/raw/master/trial"
wget -O leaked "https://github.com/radhsyn83/debian7/raw/master/leaked"
wget -O speedtest "https://github.com/radhsyn83/debian7/raw/master/speedtest"
wget -O bench-network "https://github.com/radhsyn83/debian7/raw/master/bench-network"
wget -O ramtest "https://github.com/radhsyn83/debian7/raw/master/ramtest"
wget -O dropmon "https://github.com/radhsyn83/debian7/raw/master/dropmon.sh"
wget -O user-login "https://github.com/radhsyn83/debian7/raw/master/user-login"
wget -O user-add "https://github.com/radhsyn83/debian7/raw/master/user-add"
wget -O user-expire "https://github.com/radhsyn83/debian7/raw/master/user-expire"
wget -O privasi "https://github.com/radhsyn83/debian7/raw/master/privasi"
#wget -O userlimit.sh "https://raw.github.com/yurisshOS/debian7os/master/userlimit.sh"
wget -O user-list "https://github.com/radhsyn83/debian7/raw/master/user-list"
#wget -O autokill.sh "https://raw.github.com/yurisshOS/debian7os/master/autokill.sh"
wget -O /etc/issue.net "https://github.com/radhsyn83/debian7/raw/master/banner"
wget -O user-expirelock "https://github.com/radhsyn83/debian7/raw/master/user-expirelock"
echo "0 0 * * * root /usr/bin/user-expired" > /etc/cron.d/user-expired
#echo "@reboot root /root/userlimit.sh" > /etc/cron.d/userlimit
echo "0 */12 * * * root /sbin/reboot" > /etc/cron.d/reboot
echo "* * * * * service dropbear restart" > /etc/cron.d/dropbear
#echo "@reboot root /root/autokill.sh" > /etc/cron.d/autokill
#sed -i '$ i\screen -AmdS check /root/autokill.sh' /etc/rc.local
chmod +x bench-network
chmod +x privasi
chmod +x trial
chmod +x speedtest
chmod +x user-expirelock
chmod +x ramtest
chmod +x user-login
chmod +x user-add
chmod +x user-expire
#chmod +x userlimit.sh
#chmod +x autokill.sh
chmod +x dropmon
chmod +x user-list
chmod +x leaked

# finishing
chown -R www-data:www-data /home/vps/public_html
service cron restart
service nginx start
service php-fpm start
service vnstat restart
#service openvpn restart
service snmpd restart
service ssh restart
service dropbear restart
service fail2ban restart
service squid3 restart
service webmin restart
rm -rf ~/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile

# info
clear
echo "Autoscript Include:" | tee log-install.txt
echo "===========================================" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Service"  | tee -a log-install.txt
echo "-------"  | tee -a log-install.txt
echo "OpenSSH  : 22, 143"  | tee -a log-install.txt
echo "Dropbear : 443, 110, 109"  | tee -a log-install.txt
echo "Squid3   : 80, 8080 (limit to IP SSH)"  | tee -a log-install.txt
#echo "OpenVPN  : TCP 1194 (client config : http://$MYIP:81/client.ovpn)"  | tee -a log-install.txt
echo "badvpn   : badvpn-udpgw port 7300"  | tee -a log-install.txt
#echo "PPTP VPN  : Create User via Putty (echo "username pptpd password *" >> /etc/ppp/chap-secrets)"  | tee -a log-install.txt
echo "nginx    : 81"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Tools"  | tee -a log-install.txt
echo "-----"  | tee -a log-install.txt
echo "axel, bmon, htop, iftop, mtr, rkhunter, nethogs: nethogs venet0"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Script"  | tee -a log-install.txt
echo "------"  | tee -a log-install.txt
echo "1. screenfetch"  | tee -a log-install.txt
echo "2. trial = Membuat akun Trial"| tee -a log-install.txt
echo "3. ramtest = Cek RAM"  | tee -a log-install.txt
echo "4. speedtest --share = Speed Test VPS"  | tee -a log-install.txt
echo "5. bench-network = Cek Kualitas VPS"  | tee -a log-install.txt
echo "6. user-login = Monitoring User Login Dropbear dan OpenSSH"  | tee -a log-install.txt
echo "7. user-add 'user' 'pass' = tambah user masa aktif 30hari. 'Contoh : user-add sempai sempai123'"  | tee -a log-install.txt
echo "8. user-expired = Auto Lock User Expire tiap jam 00:00"  | tee -a log-install.txt
echo "9. user-expirelock = kunci user yang sudah expire"  | tee -a log-install.txt
echo "10.user-list = Melihat informasi semua user"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Fitur lain"  | tee -a log-install.txt
echo "----------"  | tee -a log-install.txt
echo "Webmin   : http://$MYIP:10000/"  | tee -a log-install.txt
echo "vnstat   : http://$MYIP:81/vnstat/ (Cek Bandwith)"  | tee -a log-install.txt
echo "MRTG     : http://$MYIP:81/mrtg/"  | tee -a log-install.txt
echo "Timezone : Asia/Jakarta (GMT +7)"  | tee -a log-install.txt
echo "Fail2Ban : [on]"  | tee -a log-install.txt
echo "IPv6     : [off]"  | tee -a log-install.txt
#echo "Autolimit 2 bitvise per IP to all port (port 22, 143, 109, 110, 443, 1194, 7300 TCP/UDP)"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Script Modified by Fathur Radhy (www.fb.com/radhy.only)"  | tee -a log-install.txt
echo "Credit to Yurissh OpenSource" | tee -a log-install.txt
echo "Thanks to Original Creator Kang Arie & Mikodemos" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Log Instalasi --> /root/log-install.txt"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "VPS AUTO REBOOT TIAP 12 JAM, SILAHKAN REBOOT VPS ANDA !"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "==========================================="  | tee -a log-install.txt
cd
rm -f /root/debian7.sh
