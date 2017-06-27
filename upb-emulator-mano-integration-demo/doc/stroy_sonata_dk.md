# Story: Deploy service using SONATA emulator's dummy gatekeeper

## View service descriptors
```sh
# project structure
tree demo/sonata-dk/sonata-demo-service/

# NSD
mousepad demo/sonata-dk/sonata-demo-service/sources/nsd/demo-nsd.yml

# VNFD(s)
mousepad demo/sonata-dk/sonata-demo-service/sources/vnf/apache-vnf/emulator-demo-http-apache-vnfd.yml
mousepad demo/sonata-dk/sonata-demo-service/sources/vnf/socat-vnf/emulator-demo-l4fw-socat-vnfd.yml
mousepad cat demo/sonata-dk/sonata-demo-service/sources/vnf/squid-vnf/emulator-demo-proxy-squid-vnfd.yml
```

## Environment setup

```sh
# start emulator
sudo python demo/demo_topology.py
```

## Demo storyboard

### Deploy service

```sh
# package service
son-package --project demo/sonata-dk/sonata-demo-service -n sonata-demo-service

# on-board service
son-access push --upload sonata-demo-service.son

# instantiate service
son-access push --deploy latest
```

### Start Monitoring

```sh
# start son-monitor
sudo son-monitor init
# monitor service
sudo son-monitor msd -f demo/sonata-dk/msd-dk.yml
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
