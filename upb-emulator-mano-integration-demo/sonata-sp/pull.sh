#!/bin/bash
#
# download all needed containers
#
set -x
set -e

echo "Pulling SONATA SP containers..."

#PULL THE CONTAINERS
#docker pull registry.sonata-nfv.eu:5000/son-gui
#docker pull registry.sonata-nfv.eu:5000/son-yo-gen-bss
#docker pull registry.sonata-nfv.eu:5000/son-gtkpkg
#docker pull registry.sonata-nfv.eu:5000/son-gtksrv
#docker pull registry.sonata-nfv.eu:5000/son-gtkapi
#docker pull registry.sonata-nfv.eu:5000/son-gtkfnct
#docker pull registry.sonata-nfv.eu:5000/son-gtkrec
#docker pull registry.sonata-nfv.eu:5000/son-gtkvim
#docker pull registry.sonata-nfv.eu:5000/son-catalogue-repos
#docker pull registry.sonata-nfv.eu:5000/pluginmanager
#docker pull registry.sonata-nfv.eu:5000/specificmanagerregistry
#docker pull registry.sonata-nfv.eu:5000/servicelifecyclemanagement
#docker pull registry.sonata-nfv.eu:5000/son-sp-infrabstract
#docker pull registry.sonata-nfv.eu:5000/wim-adaptor
#docker pull registry.sonata-nfv.eu:5000/son-monitor-influxdb
#docker pull registry.sonata-nfv.eu:5000/son-monitor-mysql
#docker pull registry.sonata-nfv.eu:5000/son-monitor-pushgateway
#docker pull registry.sonata-nfv.eu:5000/son-monitor-prometheus
#docker pull registry.sonata-nfv.eu:5000/son-monitor-manager
#docker pull registry.sonata-nfv.eu:5000/son-monitor-probe
#docker pull registry.sonata-nfv.eu:5000/son-monitor-vmprobe


docker pull sonatanfv/son-gui
docker pull sonatanfv/son-yo-gen-bss
docker pull sonatanfv/son-gtkpkg
docker pull sonatanfv/son-gtksrv
docker pull sonatanfv/son-gtkapi
docker pull sonatanfv/son-gtkfnct
docker pull sonatanfv/son-gtkrec
docker pull sonatanfv/son-gtkvim
docker pull sonatanfv/son-catalogue-repos
docker pull sonatanfv/pluginmanager
docker pull sonatanfv/specificmanagerregistry
docker pull sonatanfv/servicelifecyclemanagement
docker pull sonatanfv/son-sp-infrabstract
docker pull sonatanfv/wim-adaptor
docker pull sonatanfv/son-monitor-influxdb
docker pull sonatanfv/son-monitor-mysql
docker pull sonatanfv/son-monitor-pushgateway
docker pull sonatanfv/son-monitor-prometheus
docker pull sonatanfv/son-monitor-manager
docker pull sonatanfv/son-monitor-probe
docker pull sonatanfv/son-monitor-vmprobe

echo "Done."
