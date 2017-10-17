#!/bin/bash

cd /home/vagrant
echo "Installing containernet (will take some time ~30 minutes) ..."
git clone https://github.com/containernet/containernet.git
cd /home/vagrant/containernet/ansible
sudo ansible-playbook install.yml

cd /home/vagrant
echo "Installing son-emu (will take some time) ..."
# TODO rely on master branch when everything is merged
git clone -b demo-mano-integration https://github.com/mpeuster/son-emu.git
cd /home/vagrant/son-emu/ansible
sudo ansible-playbook install.yml

cd /home/vagrant/son-emu
sudo python setup.py install
sudo python setup.py develop

#echo "Running son-emu unit tests to validate installation"
#cd /home/ubuntu/son-emu
#sudo python setup.py develop
#sudo py.test -v src/emuvim/test/unittests

#sudo gpasswd -a ubuntu docker
sudo gpasswd -a vagrant docker
