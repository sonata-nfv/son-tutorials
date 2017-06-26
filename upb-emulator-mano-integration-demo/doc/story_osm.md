# Story 1

## Demo

```bash
# start emulator
sudo python son-emu/src/emuvim/examples/demo_emulator_mano_integration.py
```

### Deploy with Heat

```sh
# setup openstack clients
source vagrant/openstackrc.sh

# deploy 
openstack stack create -f yaml -t vagrant/heat/demo-service-hot.yml demostack1

# show
openstack image list
openstack stack list
openstack server list

# remove
openstack stack delete demostack1

```

### Deploy with OSM

#### Start OSM

```sh
service-openmano start
```

#### Add datacenter(s) to OSM
```sh
# create tenant
openmano tenant-create osm
export OPENMANO_TENANT=osm
# create datacenter(s)
openmano datacenter-create openstack-site http://127.0.0.1:6001/v2.0 --type openstack --description "PoP1"
openmano datacenter-create openstack-site2 http://127.0.0.1:6002/v2.0 --type openstack --description "PoP2"
# attach datacenter(s)
openmano datacenter-attach openstack-site --user=username --password=password --vim-tenant-name=tenantName
openmano datacenter-attach openstack-site2 --user=username --password=password --vim-tenant-name=tenantName
# check
openmano datacenter-list
```

#### Create VNF(s)
```sh
openmano vnf-create ~/vagrant/osm/vnf-http-apache-osm.yml
openmano vnf-create ~/vagrant/osm/vnf-proxy-squid-osm.yml
openmano vnf-create ~/vagrant/osm/vnf-l4fw-socat-osm.yml

openmano vnf-list -v
```

#### Create & deploy scenario
```sh
# upload
openmano scenario-create ~/vagrant/osm/scenario-demo.yml
# create instance on first PoP
openmano instance-scenario-create --scenario demo --name inst1 --datacenter openstack-site
# create second instance on second PoP
openmano instance-scenario-create --scenario demo --name inst2 --datacenter openstack-site2

openmano instance-scenario-list -v
```

### Deploy with SONATA

```sh
TODO
```

### Start Monitoring

```sh
sudo son-monitor init
sudo son-monitor msd -f vagrant/heat/msd-heat.yml
sudo son-monitor init stop
```

### Use the service

#### Inside the VM
```sh
# HTTP: 
curl 172.17.0.3
# L4FW + HTTP:
curl 172.17.0.4:8899
# PROXY + HTTP:
curl -x http://172.17.0.2:3128 20.0.0.1
# PROXY + L4FW + HTTP:
curl -x http://172.17.0.2:3128 20.0.0.2:8899
# Full downlaod of video file
curl -x http://172.17.0.4:3128 20.0.0.2:8899/bunny.mp4 > /dev/null
```

#### From host machine

First `scripts/setup_net.sh` needs to be executed to forward traffic from the VMs host net. You can now configure Firefox on the Host machine to use the proxy `192.168.11.10:3128` and surf to http://20.0.0.2:8899 to show CatTube.

```sh
curl -x http://192.168.11.10:3128 20.0.0.2:8899
```

## Dashboards

* Emulator Dashboard: http://127.0.0.1:5001/dashboard/index_upb.html
* Grafana monitoring: http://127.0.0.1:3000
* cAdvisor: http://127.0.0.1:8081/docker/


## Helper

### Other infos

* there should not be more than 20 Docker images on the machine (otherwise the OpenStack image clients/APIs might make trouble)

## TODO

* OSM instance delete results in an error
