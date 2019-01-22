#!/bin/bash

sleep 1

# IP setup (we need to try different names in different scenarios, but never eth0 which is the docker if)
declare -a PORTS=("vnf1-mgmt-0")

for p in "${PORTS[@]}"
do
    ifconfig $p down
    ifconfig $p 20.0.0.2 netmask 255.255.255.0
    ifconfig $p up
done

ifconfig > /ifconfig.debug
