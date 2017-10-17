#!/bin/bash
git clone https://github.com/mpeuster/son-cli.git

sudo apt-get install -y python3 python3-pycparser build-essential python3-dev python3-pip libyaml-dev libffi-dev libssl-dev tcpdump gfortran libopenblas-dev liblapack-dev pkg-config libfreetype6-dev libpng-dev python3-numpy python3-scipy python3-matplotlib

sudo pip3 install numpy scipy matplotlib docker Flask

sudo pip install docker-compose

cd /home/vagrant/son-cli/

sudo python3 setup.py develop
