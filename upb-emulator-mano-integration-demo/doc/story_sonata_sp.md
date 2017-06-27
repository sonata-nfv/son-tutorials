#  Story: Deploy service using SONATA SP

## View service descriptors
```sh
# NSD
mousepad son-sp-infrabstract/vim-adaptor/adaptor/YAML/emulator-demo-nsd.yml

# VNFD(s)
mousepad son-sp-infrabstract/vim-adaptor/adaptor/YAML/emulator-demo-http-apache-vnfd.yml
mousepad son-sp-infrabstract/vim-adaptor/adaptor/YAML/emulator-demo-l4fw-socat-vnfd.yml
mousepad son-sp-infrabstract/vim-adaptor/adaptor/YAML/emulator-demo-proxy-squid-vnfd.yml
```

## Environment setup

```
# start SONATA SP helper components (databases etc.) 
demo/sonata-sp/deploy_environment.sh

# start emulator
sudo python demo/demo_topology.py
```

## Demo soryboard

### Deploy service

```sh
# deploy service using infrastructure abstraction module
demo/sonata-sp/sonata_deploy_service.sh
```

### Start Monitoring

```sh
# start son-monitor
sudo son-monitor init
# monitor service
sudo son-monitor msd -f demo/sonata-sp/msd-sp.yml
# (stop monitoring)
sudo son-monitor init stop

# open Chrome browser and use the bookmarks to navigate to Grafana dashboard
```

### Use the service

```sh
# full downlaod of video file
curl -x http://172.17.0.6:3128 20.0.0.2:8899/bunny.mp4 > /dev/null

# or open Firefox and browe to 20.0.0.2:8899 to visit "CatTube" and watch the video
```

