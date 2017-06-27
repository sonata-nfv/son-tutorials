#  Story: Deploy service using SONATA SP

## View service descriptors
```sh
# NSD
mousepad TODO

# VNFD(s)
mousepad TODO
mousepad TODO
mousepad TODO
```

## Environment setup

```
# start SONATA SP helper components (databases etc.) 
demo/sonata-sp/deploy_environment.sh

# start emulator
sudo python demo/demo_topology.py
```

## Demo soryboard

```sh
# deploy service using infrastructure abstraction module
demo/sonata-sp/sonata_deploy_service.sh
```
