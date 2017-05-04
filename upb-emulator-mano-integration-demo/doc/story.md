# Story 1
## Preparation

```bash
TODO ENV etc. (depends on used VM, see also demo.org)
```


## Demo

```bash
# start emulator
sudo python son-emu/src/emuvim/examples/demo_emulator_mano_integration.py
```

### Deploy with Heat

```bash
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

#### Add datacenter(s) to OSM
```bash
# create tenant
./openmano tenant-create osm
# create datacenter(s)
./openmano datacenter-create openstack-site http://127.0.0.1:6001/v2.0 --type openstack --description "PoP1"
./openmano datacenter-create openstack-site2 http://127.0.0.1:6002/v2.0 --type openstack --description "PoP2"
# attach datacenter(s)
./openmano datacenter-attach openstack-site --user=username --password=password --vim-tenant-name=tenantName
./openmano datacenter-attach openstack-site2 --user=username --password=password --vim-tenant-name=tenantName
```

#### Create VNF(s)
```bash
./openmano vnf-create ~/son-int-demo/osm/vnf-http-apache-osm.yml
./openmano vnf-create ~/son-int-demo/osm/vnf-proxy-squid-osm.yml
./openmano vnf-create ~/son-int-demo/osm/vnf-l4fw-socat-osm.yml

./openmano vnf-list -v
```

#### Create & deploy scenario
```bash
# upload
./openmano scenario-create ~/son-int-demo/osm/scenario-demo.yml
# create instance on first PoP
./openmano scenario-deploy demo inst1 --datacenter openstack-site
# create second instance on second PoP
./openmano scenario-deploy demo inst2 --datacenter openstack-site2

./openmano instance-scenario-list -v
```

### Deploy with SONATA

```bash
TODO
```

### Use the service

```bash
# HTTP: 
curl 172.17.0.3
# L4FW + HTTP:
curl 172.17.0.4:8899
# PROXY + HTTP:
curl -x http://172.17.0.2:3128 20.0.0.1
# PROXY + L4FW + HTTP:
curl -x http://172.17.0.2:3128 20.0.0.2:8899
```

## Helper

* there should not be more than 20 Docker image on the machine (otherwise the OpenStack image clients/APIs might make trouble)

## TODO

* OSM instance delete results in an error
