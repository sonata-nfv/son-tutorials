# Story: Deploy service using SONATA emulator's dummy gatekeeper

## Environment setup

```sh
# start emulator
sudo python ~/son-tutorials/upb-emulator-mano-integration-demo/demo_topology.py
```

## Demo storyboard

```sh
cd ~/son-tutorials/upb-emulator-mano-integration-demo/sonata-dk

# package service
son-package --project sonata-demo-service -n sonata-demo-service

# on-board service
son-access push --upload sonata-demo-service.son

# instantiate service
son-access push --deploy latest
```
