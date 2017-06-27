## Use the service

### Inside the VM
```sh
# HTTP: 
curl 172.17.0.3
# L4FW + HTTP:
curl 172.17.0.4:8899
# PROXY + HTTP:
curl -x http://172.17.0.2:3128 20.0.0.1
# PROXY + L4FW + HTTP:
curl -x http://172.17.0.2:3128 20.0.0.2:8899
# Full downlaod of video file
curl -x http://172.17.0.4:3128 20.0.0.2:8899/bunny.mp4 > /dev/null
```

### From host machine

First `scripts/setup_net.sh` needs to be executed to forward traffic from the VMs host net. You can now configure Firefox on the Host machine to use the proxy `192.168.11.10:3128` and surf to http://20.0.0.2:8899 to show CatTube.

```sh
curl -x http://192.168.11.10:3128 20.0.0.2:8899
```

## Dashboards

* Emulator Dashboard: http://127.0.0.1:5001/dashboard/index_upb.html
* Grafana monitoring: http://127.0.0.1:3000
* cAdvisor: http://127.0.0.1:8081/docker/
