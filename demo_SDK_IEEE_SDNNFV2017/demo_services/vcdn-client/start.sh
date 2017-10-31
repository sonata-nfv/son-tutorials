#! /bin/bash


echo "start squid client"

# delete default route (it is the docker0 interface)
ip route del default

# get the sap interface name (not 'eth0' and not 'lo')
intf=$(ifconfig -a | sed 's/[ \t].*//;/^\(lo\|\)$/d' | sed 's/[ \t].*//;/^\(eth0\|\)$/d')
echo "default interface: $intf"
ip route add default dev $intf

# start squid client (is configuration specific)
#python squid_client.py 1 1 'http://10.20.1.1:8888/file/5' > vcdn_client.log 2>&1
