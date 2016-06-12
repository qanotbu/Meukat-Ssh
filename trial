#!/bin/bash
Login="trial"
Pass=`</dev/urandom tr -dc a-z1-3 | head -c3`
IP=`ifconfig venet0:0| awk 'NR==2 {print $2}'| awk -F: '{print $2}'`
#clear
useradd -s /bin/false -m $Login
echo -e "$Pass\n$Pass\n" | passwd $Login &> /dev/null
#clear
echo -e "********************\n\nHost: $IP\nPort: 443\nUser: $Login\nPassword: $Pass\n\n\n********************\n\n"

