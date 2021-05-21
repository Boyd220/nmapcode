 #!/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
sleep 20

default_if=$(ip route list | awk '/^default/ {print $5}')

iptoscan=$(ip -o -f inet addr show $default_if | awk '{print $4}')

networkmask=$(cut -d "/" -f2 <<< "$iptoscan")

originalnetworkmask=$(ifconfig eth0 | awk '/netmask/{split($4,a,":"); print a[1]}')

currentip=$(hostname -I | awk '{print $1}')

IFS=. read -r i1 i2 i3 i4 <<< "$currentip"
IFS=. read -r m1 m2 m3 m4 <<< "$originalnetworkmask"

networkaddress=$((i1 & m1)).$((i2 & m2)).$((i3 & m3)).$((i4 & m4))

scanthis=$networkaddress/$networkmask

sudo nmap $scanthis -sn -oG nmap-list.txt

sudo python newmailing.py
