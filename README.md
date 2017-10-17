# son-tutorials
In this repository, dissemination material for the SONATA project is made available.

## Demos


* [SONATA SDK demo/tutorial](https://github.com/sonata-nfv/son-tutorials/tree/master/demo_vm_SDK) (Softnetworking 2017, Venice, Italy)
* [Containernet and SONATA Emulator demo/tutorial](https://github.com/sonata-nfv/son-tutorials/tree/master/upb-containernet-emulator-summerschool-demo) (Summerschool 2017, Karlstad, Sweden)
* [SONATA Emulator to MANO integration demo](https://github.com/sonata-nfv/son-tutorials/tree/master/upb-emulator-mano-integration-demo) (IEEE NetSoft 2017, Bologna, Italy)
* [SONATA SDK demo](https://github.com/sonata-nfv/son-tutorials/tree/master/demo_SDK_IEEE_SDNNFV2017) (IEEE SDN-NFV 2017, Berlin)


The VM exposes several ports to the host machine to access several tools of the SONATA SDK:
* 5000 # dummy gatekeeper
* 5001 # REST API
* 8081 # cAdvisor
* 9090 # Prometheus
* 9091 # Prometheus push gateway 
* 3000 # Grafana
* 8080 # Editor, browse to: http://localhost:8080/index.html
* 9080 # son-validate-gui, browse to: http://localhost:9080 (only in IEEE SDN-NFV demo)
* 5050 # son-validate-api service (only in IEEE SDN-NFV demo)
* The emulator has a dashboard at: http://localhost:5001/dashboard/index.html
* SSH login: user: `sonata` password: `sonata` at port 2222 `ssh -p 2222 sonata@localhost`


## Contributors (see individual demos for contact details)
* Steven Van Rossem (https://github.com/stevenvanrossem)
* Thomas Soenen (https://github.com/tsoenen)
* Wouter Tavernier (https://github.com/wtaverni)
* Manuel Peuster (https://github.com/mpeuster)

