#! /bin/bash

echo "start squid server"
sysctl -w net.ipv4.conf.all.proxy_arp=1
/usr/sbin/squid3 -d 5


