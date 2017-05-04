#!/bin/bash

cd /home/ubuntu
echo "Installing containernet (will take some time ~30 minutes) ..."
git clone https://github.com/containernet/containernet.git
cd /home/ubuntu/containernet/ansible
sudo ansible-playbook install.yml

cd /home/ubuntu
echo "Installing son-emu (will take some time) ..."
git clone -b int-demo https://github.com/mpeuster/son-emu.git
cd /home/ubuntu/son-emu/ansible
sudo ansible-playbook install.yml

cd /home/ubuntu/son-emu
sudo python setup.py install
sudo python setup.py develop

#echo "Running son-emu unit tests to validate installation"
#cd /home/ubuntu/son-emu
#sudo python setup.py develop
#sudo py.test -v src/emuvim/test/unittests   
