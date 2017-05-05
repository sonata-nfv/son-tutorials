#!/bin/bash

# RO (openmano)
cd /home/vagrant
git clone https://osm.etsi.org/gerrit/osm/RO.git
cd /home/vagrant/RO
git checkout v2.0
sudo scripts/install-openmano.sh -u root -p root --noclone --forcedb --develop


# SO
cd /home/vagrant
git clone https://osm.etsi.org/gerrit/osm/SO.git
cd /home/vagrant/SO
git checkout v2.0
sudo ./BUILD.sh
#make -j2
sudo make install

# UI
cd /home/vagrant
git clone https://osm.etsi.org/gerrit/osm/UI.git
cd /home/vagrant/UI
git checkout v2.0
make -j2
sudo make install

# start
# sudo -H /usr/rift/rift-shell -r -i /usr/rift -a /usr/rift/.artifacts -- ./demos/launchpad.py --use-xml-mode --test-name "launchpad"
