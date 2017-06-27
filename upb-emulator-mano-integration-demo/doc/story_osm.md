# Story: Deploy service using OSM

## Environment setup

```sh
# start emulator
sudo python demo/demo_topology.py
```

```sh
# cleanup old DB entries (in ~/osm/RO)
sudo scripts/install-openmano.sh -u root -p root --develop --noclone --forcedb --no-install-packages

# start OSM
service-openmano start
```

## Demo storyboard

### Add datacenter(s) to OSM
```sh
# create tenant
openmano tenant-create osm
export OPENMANO_TENANT=osm
# create datacenter(s)
openmano datacenter-create pop1 http://127.0.0.1:6003/v2.0 --type openstack --description "osm-pop1"
openmano datacenter-create pop2 http://127.0.0.1:6004/v2.0 --type openstack --description "osm-pop2"
# attach datacenter(s)
openmano datacenter-attach pop1 --user=username --password=password --vim-tenant-name=tenantName
openmano datacenter-attach pop2 --user=username --password=password --vim-tenant-name=tenantName
# check
openmano datacenter-list
```

### Create VNF(s)
```sh
openmano vnf-create ~/demo/osm/vnf-http-apache-osm.yml
openmano vnf-create ~/demo/osm/vnf-proxy-squid-osm.yml
openmano vnf-create ~/demo/osm/vnf-l4fw-socat-osm.yml

openmano vnf-list -v
```

### Create & deploy scenario
```sh
# upload
openmano scenario-create ~/demo/osm/scenario-demo.yml
# create instance on first PoP
openmano instance-scenario-create --scenario demo --name inst1 --datacenter pop1
# create second instance on second PoP
openmano instance-scenario-create --scenario demo --name inst2 --datacenter pop2

openmano instance-scenario-list -v
```


## Start Monitoring

```sh
sudo son-monitor init
sudo son-monitor msd -f vagrant/heat/msd-heat.yml
sudo son-monitor init stop
```

## Use the service

### Inside the VM
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

### From host machine

First `scripts/setup_net.sh` needs to be executed to forward traffic from the VMs host net. You can now configure Firefox on the Host machine to use the proxy `192.168.11.10:3128` and surf to http://20.0.0.2:8899 to show CatTube.

```sh
curl -x http://192.168.11.10:3128 20.0.0.2:8899
```

## Dashboards

* Emulator Dashboard: http://127.0.0.1:5001/dashboard/index_upb.html
* Grafana monitoring: http://127.0.0.1:3000
* cAdvisor: http://127.0.0.1:8081/docker/


