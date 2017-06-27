# Story: Deploy service using SONATA emulator's dummy gatekeeper

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

# or open Firefox and browe to 20.0.0.2:8899 to visit "CatTube" and watch the video
```
