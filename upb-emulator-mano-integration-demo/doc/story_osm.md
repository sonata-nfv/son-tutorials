# Story: Deploy service using OSM

## View service descriptors
```sh
# NSD
mousepad demo/osm/scenario-demo.yml

# VNFD(s)
mousepad demo/osm/vnf-http-apache-osm.yml
mousepad demo/osm/vnf-l4fw-socat-osm.yml
mousepad demo/osm/vnf-proxy-squid-osm.yml
```

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
openmano datacenter-create pop1 http://172.0.0.101:6003/v2.0 --type openstack --description "osm-pop1"
openmano datacenter-create pop2 http://172.0.0.101:6004/v2.0 --type openstack --description "osm-pop2"
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

### Start Monitoring

```sh
# start son-monitor
sudo son-monitor init
# monitor service
sudo son-monitor msd -f demo/osm/msd-osm.yml
# (stop monitoring)
sudo son-monitor init stop

# open Chrome browser and use the bookmarks to navigate to Grafana dashboard
```

### Use the service

```sh
# full downlaod of video file
curl -x http://172.17.0.4:3128 20.0.0.2:8899/bunny.mp4 > /dev/null

# open browser and access the service through the proxy VNF
demo/scripts/open_service_with_proxy.py &

# or click "Chromium Web Browser w. Proxy" on Desktop to visit "CatTube" and watch the video
```



