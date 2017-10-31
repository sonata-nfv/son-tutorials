#! /bin/bash

SQUID1_IP="10.20.0.3:3128"
SQUID2_IP="http://10.20.0.4:3128/"

echo "set http_proxy to: $SQUID2_IP"
echo "export http_proxy=$SQUID2_IP" >> ~/.profile
echo "export http_proxy=$SQUID2_IP" >> ~/.bashrc
echo "$SQUID2_IP" > /http_proxy_setting
#refresh proxy setting
kill -SIGHUP $(pgrep python)

