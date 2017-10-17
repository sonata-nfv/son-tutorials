# SDK Demo Virtual Machine
A VM can be automatically generated that has all SONATA SDK features installed, 
using [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/).

These are the files for the IEEE SDN-NFV demo (Nov 2017).

**Publication**: "A Network Service Development Kit Supporting the End-to-End Lifecycle of NFV-based Telecom Services", IEEE SDN-NFV 2017, 
S. Van Rossem (Ghent University & iMinds – IBCN, Belgium); M. Peuster (Paderborn University, Germany); L. Conceição (Ubiwhere, Portugal); H. Razzaghi Kouchaksaraei (Paderborn University, Germany); W. Tavernier and D. Colle (IMEC – Ghent University, Belgium); M. Pickavet and P. Demeester (Ghent University – iMinds, Belgium)

The VM (based on Ubuntu Server xenial) is built by executing: `vagrant up`

#### Demo VM interfaces
The VM exposes several ports to the host machine to access several tools of the SONATA SDK:
* 5000 # dummy gatekeeper
* 5001 # REST API
* 8081 # cAdvisor
* 9090 # Prometheus
* 9091 # Prometheus push gateway 
* 3000 # Grafana
* 8080 # Editor, browse to: http://localhost:8080/index.html
* 9080 # son-validate-gui, browse to: http://localhost:9080 
* 5050 # son-validate-api service 
* The emulator has a dashboard at: http://localhost:5001/dashboard/index.html
* SSH login: user: `sonata` password: `sonata` at port 2222 `ssh -p 2222 sonata@localhost`


#### Demo VM example usage

After startup, SSH into the VM as sonata user.
The following SONATA repositories are installed in /home/sonata :
* son-emu
* son-editor
* son-cli
* son-examples

The son-editor should be started at boot and available when browsing to: 
http://localhost:8080/index.html

A dedicated GitHub account was made for this SONATA demo to login into the editor:  
user: sonatademo password: s0natademo

The son-emulator needs to be started up with a dedicated topology:  
```
cd son-emu
sudo python src/emuvim/examples/demo_topo_1pop.py
```

#### Demo VM example services

* ovs_and_ryu: Openflow switch VNF (ovs) with a controller VNF (Ryu)
* vEPC: to be added
* vCDN: to be added
