#!/usr/bin/env bash

# Usage:
# timeout 10 docker_iptables.sh
#
# Use the builtin shell timeout utility to prevent infinite loop (see below)
#
# This script is based on: http://rudijs.github.io/2015-07/docker-restricting-container-access-with-iptables/

if [ ! -x /usr/bin/docker ]; then
    echo "No docker."
    exit
fi

# Check if the PRE_DOCKER chain exists, if it does there's an existing reference to it.
iptables -C FORWARD -o docker0 -j PRE_DOCKER

if [ $? -eq 0 ]; then
    # Remove reference (will be re-added again later in this script)
    iptables -D FORWARD -o docker0 -j PRE_DOCKER
    # Flush all existing rules
    iptables -F PRE_DOCKER
else
    # Create the PRE_DOCKER chain
    iptables -N PRE_DOCKER
fi

# Default action
iptables -I PRE_DOCKER -j DROP

# Docker Containers allow access from UPB network
#iptables -I PRE_DOCKER -i eth0 -s 131.234.0.0/16 -j ACCEPT

# Docker internal use
iptables -I PRE_DOCKER -o docker0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -I PRE_DOCKER -i docker0 ! -o docker0 -j ACCEPT
iptables -I PRE_DOCKER -m state --state RELATED -j ACCEPT
iptables -I PRE_DOCKER -i docker0 -o docker0 -j ACCEPT

# Double check, wait for docker socket (upstart docker.conf already does this)
while [ ! -e "/var/run/docker.sock" ]; do echo "Waiting for /var/run/docker.sock..."; sleep 1; done

# Get IPs of Docker container for open access
GUI_IP=$(/usr/bin/docker inspect --format='{{.NetworkSettings.IPAddress}}' son-gui)
BSS_IP=$(/usr/bin/docker inspect --format='{{.NetworkSettings.IPAddress}}' son-bss)
GTK_IP=$(/usr/bin/docker inspect --format='{{.NetworkSettings.IPAddress}}' son-gtkapi)

# Docker containers full public access
iptables -I PRE_DOCKER -i eth0 -p tcp -d $GUI_IP --dport 80  -j ACCEPT
iptables -I PRE_DOCKER -i eth0 -p tcp -d $BSS_IP --dport 25001  -j ACCEPT
iptables -I PRE_DOCKER -i eth0 -p tcp -d $GTK_IP --dport 32001 -j ACCEPT

# Finally insert the PRE_DOCKER table before the DOCKER table in the FORWARD chain.
iptables -I FORWARD -o docker0 -j PRE_DOCKER


echo "firewall.sh done."
