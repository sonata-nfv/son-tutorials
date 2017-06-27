# Story: Deploy service using SONATA emulator's dummy gatekeeper

## Environment setup

```sh
# start emulator
sudo python demo/demo_topology.py
```

## Demo storyboard

```sh
# package service
son-package --project demo/sonata-dk/sonata-demo-service -n sonata-demo-service

# on-board service
son-access push --upload sonata-demo-service.son

# instantiate service
son-access push --deploy latest
```
