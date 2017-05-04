#!/bin/bash

cd /home/ubuntu
git clone https://osm.etsi.org/gerrit/osm/RO.git
# install
cd /home/ubuntu/RO
git checkout v2.0
sudo scripts/install-openmano.sh -u root -p root --noclone --forcedb --develop

