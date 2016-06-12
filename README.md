DEBIAN 7 AUTO SCRIPT
=======

Script Debian7 For SSH

Cara penggunaan :
# wget https://github.com/radhsyn83/debian7/raw/master/debian7.sh
# sh ./debian7.sh

Tunggu sampai proses selesai.
kurang lebih 1 jam tergantung jaringan anda

Autoscript Include:
===========================================

Service
-------
OpenSSH  : 22, 143
Dropbear : 443, 110, 109
Squid3   : 80, 8080 (limit to IP SSH)
badvpn   : badvpn-udpgw port 7300
nginx    : 81

Tools
-----
axel, bmon, htop, iftop, mtr, rkhunter, nethogs: nethogs venet0

Script
------
1. screenfetch
2. trial "namauser" = Membuat akun Trial
3. ramtest = Cek RAM
4. speedtest --share = Speed Test VPS
5. bench-network = Cek Kualitas VPS
6. user-login = Monitoring User Login Dropbear dan OpenSSH
7. user-add 'user' 'pass' = tambah user masa aktif 30hari. 'Contoh : user-add sempai sempai123'
8. user-expired = Auto Lock User Expire tiap jam 00:00
9. user-expirelock = kunci user yang sudah expire
10. user-list = Melihat informasi semua user

Fitur lain
----------
Webmin   : http://:10000/

vnstat   : http://:81/vnstat/ (Cek Bandwith)

MRTG     : http://:81/mrtg/

Timezone : Asia/Jakarta (GMT +7)

Fail2Ban : [on]

IPv6     : [off]


Script Modified by Fathur Radhy (www.fb.com/radhy.only)
Credit to Yurissh OpenSource
Thanks to Original Creator Kang Arie & Mikodemos
