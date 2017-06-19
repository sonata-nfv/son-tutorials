# son-tutorials
In this repository, dissemination material for the SONATA project is made available.

### SDK Demo Virtual Machine
A VM can be automatically generated that has all SONATA SDK features installed, 
using [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/).

The files can be found in the folder `demo_vm_SDK`.

The VM is built by executing: `vagrant up`

The VM exposes several ports to the host machine to access several tools of the SONATA SDK:
* 5000 # dummy gatekeeper
* 5001 # REST API
* 8081 # cAdvisor
* 9090 # Prometheus
* 9091 # Prometheus push gateway 
* 3000 # Grafana
* 8080 # Editor, browse to: http://localhost:8080/index.html
* The emulator has a dashboard at: http://localhost:5001/dashboard/index.html
* SSH login: user: `sonata` password: `sonata` at port 2222
  `ssh -X -p 2222 sonata@localhost`

To use all features of son-emu and son-cli, the X server settings must be taken into account and X11 should be enabled when opening an SSH terminal to the VM.
Further info about this is documented [here](https://github.com/sonata-nfv/son-emu/wiki/VNF-configuration-terminal)


#### Demo VM example usage

After startup, SSH into the VM as sonata user.
The following SONATA repositories are installed in /home/sonata :
* [son-emu](https://github.com/sonata-nfv/son-emu)
* [son-editor](https://github.com/sonata-nfv/son-editor-backend)
* [son-cli](https://github.com/sonata-nfv/son-cli )
* [son-examples](https://github.com/sonata-nfv/son-examples)

The son-editor should be started at boot and available when browsing to: 
http://localhost:8080/index.html

A dedicated GitHub account was made for this SONATA demo to login into the editor:  
user: sonatademo  
password: s0natademo

The son-emulator needs to be started up with a dedicated topology:
```
cd son-emu
sudo python src/emuvim/examples/demo_topo_1pop.py
```

After this step, an NSD from the editor can be uploaded to the emulator and the [son-cli](https://github.com/sonata-nfv/son-cli) tools can be further used to manipulate the deployed service. Some deployment examples are described [here](https://github.com/sonata-nfv/son-emu/wiki).
