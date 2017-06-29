# Story: Deploy service using OSM full installation

## View service descriptors
```sh
# NSD
mousepad demo/osm/pkggen/demo_nsd/demo_nsd.yaml

# VNFD(s)
mousepad demo/osm/pkggen/http/http_vnfd.yaml
mousepad demo/osm/pkggen/l4fw/l4fw_vnfd.yaml
mousepad demo/osm/pkggen/proxy/proxy_vnfd.yaml
```

## Environment setup

```sh
# start emulator
sudo python demo/demo_topology.py
```

OSM is already installed and running inside an lxc container:
```sh
lxc list
lxc exec osmr2 -- bash
lxc list
```

Logs:
```sh
less /var/log/osm/openmano.log
```

You have to set the route to be able to access the OSM launchpad (do on host):
```
demo/osm/set_route.sh
```

## Demo storyboard

### Open OSM Dashboard

Use Chrome and browse to `https://10.87.78.189:8443` (you may need to accept the unsecure certificate!).

Login: User = `admin` Password = `admin`

### On-board service

You can onboard the service by dragging the VNFD and NSD packages to the left bar of the GUI:

```
# VNFD packages
demo/osm/pkggen/http.tar.gz
demo/osm/pkggen/l4fw.tar.gz
demo/osm/pkggen/proxy.tar.gz
# NSD package
demo/osm/pkggen/demo_nsd.tar.gz
```

You can re-pack the descriptors with `./pack.sh` in the `pkggen` folder.

### Instanitate service

* `LAUNCHPAD > Instantiate`
* Select service with name `demo`
* `Next`
* Select instance name and target PoP(s)
* `LAUNCH`
* (Attention: The GUI will stay in `Finished instantiation of 3 VNFs` state. However, the service is fully deployed on the emulator. Reason might by the missing cloud init and management functionalities.)

### Start Monitoring

```sh
# start son-monitor
sudo son-monitor init
# monitor service
sudo son-monitor msd -f demo/osm/msd-osm-gui.yml
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

## Setup helper
Already performend, not needed for demo, just for documentation!

Create and attach PoPs (do in RO container):
```sh
export OPENMANO_TENANT=osm
openmano tenant-create osm
openmano datacenter-create pop1 http://172.0.0.101:6003/v2.0 --type openstack --description "osm-pop1"
openmano datacenter-create pop2 http://172.0.0.101:6004/v2.0 --type openstack --description "osm-pop2"
openmano datacenter-attach pop1 --user=username --password=password --vim-tenant-name=tenantName
openmano datacenter-attach pop2 --user=username --password=password --vim-tenant-name=tenantName
```

