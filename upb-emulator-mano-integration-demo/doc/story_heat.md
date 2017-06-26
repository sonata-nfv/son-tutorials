# Story: Deploy service using HEAT template

## Evironment setup

```sh
# setup openstack clients
source openstackrc.sh
```

## Demo storyboard

```sh
# deploy 
openstack stack create -f yaml -t heat/demo-service-hot.yml demo1

# show
openstack image list
openstack stack list
openstack server list

# remove
openstack stack delete demo1
# press y + <enter> to confirm
```

