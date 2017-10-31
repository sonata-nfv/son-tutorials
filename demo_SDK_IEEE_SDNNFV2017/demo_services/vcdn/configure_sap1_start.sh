#! /bin/bash

SQUID1_IP="http://10.20.0.3:3128/"

echo "set http_proxy to: $SQUID1_IP"
echo "export http_proxy=$SQUID1_IP" >> ~/.profile
echo "export http_proxy=$SQUID1_IP" >> ~/.bashrc
echo "$SQUID1_IP" > /http_proxy_setting
#refresh proxy setting
#kill -SIGHUP $(pgrep python)
# start vCDN downloads
python squid_client.py 1 1 'http://10.20.1.1:8888/file/0.2' &

