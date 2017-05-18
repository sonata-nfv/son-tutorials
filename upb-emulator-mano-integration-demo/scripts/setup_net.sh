#!/bin/bash

# Helper script to setup NAT rules before/after containers have been started
sudo iptables -t nat -A  DOCKER -p tcp --dport 3128 -j DNAT --to-destination 172.17.0.2:3128
#sudo iptables -A DOCKER -p tcp --dport 3128  --j ACCEPT
#sudo iptables -t nat -A  DOCKER -p tcp --dport 80 -j DNAT --to-destination 172.17.0.3:80
