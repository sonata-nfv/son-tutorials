# Story: Deploy service using HEAT template

## View service descriptors
mousepad demo/heat/demo-service-hot.yml

## Evironment setup

```sh
# start emulator
sudo python demo/demo_topology.py
```

## Demo storyboard

### Deploy service
```sh
# deploy stack
openstack stack create -f yaml -t demo/heat/demo-service-hot.yml stack1

# show
openstack image list
openstack stack list
openstack server list

# remove
openstack stack delete stack1
# press y + <enter> to confirm
```

### Start Monitoring

```sh
# start son-monitor
sudo son-monitor init
# monitor service
sudo son-monitor msd -f demo/heat/msd-heat.yml
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
