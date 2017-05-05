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
#sudo ./BUILD.sh
