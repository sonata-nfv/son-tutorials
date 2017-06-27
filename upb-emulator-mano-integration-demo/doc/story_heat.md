# Story: Deploy service using HEAT template

## Evironment setup

```sh
# start emulator
sudo python demo/demo_topology.py
```

## Demo storyboard

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

