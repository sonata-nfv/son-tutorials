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
* SSH login: user: `sonata` password: `sonata` at port 2222 `ssh -X -p 2222 sonata@localhost`


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

#### Step 0: Preparations
* install vagrant and virtualbox
* build the VM by executing `vagrant up` in this directory (where Vagrantfile is), this will take about 30mins.
* when VM is ready ,it is running and son-editor and son-validate should already be running.
* ssh into the VM: SSH login: user: `sonata` password: `sonata` at port 2222 `ssh -X -p 2222 sonata@localhost`
* start a demo topology in the emulator:
```
cd son-emu
sudo python src/emuvim/examples/demo_topo_1pop.py
```
#### Step 1: Show the descriptors in the editor
* on the host, open a browser to the editor: http://localhost:8080
* move to	demo -> edit -> ovs_and_ryu -> edit vnfd and nsd    
From the nsd click on **upload** and the package should be created and sent to the emulator (make sure emulator is started , see above).
The service should automatically deploy on the emulator. 

#### Step 2: Show the validation of the descriptors and packages
* on the host, open a browser to the validator: http://localhost:9080
* in the validator, enter the path to the service descriptors (where they are created by the editor): 
`/home/sonata/son-editor-backend/workspaces/sonatademo/demo/projects/ovs_and_ryu`
Check *Syntax*, *Integrity*, *Topology* in the validator to enable all the checks, and click **Validate**.
Any validation errors will show and the service graph will be drawn in the tool.

#### Step 3: Show deployment on the emulator
* on the host, open a browser to the emulator dashboard: http://localhost:5001/dashboard/index.html
After the deployment of a service (via the editor in step 1, or manually), this dashboard shows the deployed VNFs and their interfaces in the service (need to refresh the browser).
These parameters are needed to configure the VNFs:
* **ovs_and_ryu**: The ovs switch needs to be configured with the correct ip address of the controller and the correct flow entries must be inserted. The configuration script is located in `demo_services/ovs_and_ryu/configure_ovs1.sh`. The correct IP addresses should be filled (check them in the dashboard). To execute the configuration script: 
```
cd demo_services/ovs_and_ryu/
son-exec ovs1 configure_ovs1.sh
```
The `son-exec` script executes the script inside the specified VNF. This is the same action as woul have been done by the configuration-ssm. So this is a way of testing this script.

An xterm can be started for a VNF by double-clicking the VNF node on the graph in the dashboard (more info [here](https://github.com/sonata-nfv/son-emu/wiki/VNF-configuration-terminal)).

#### Step 4: Execute profiling checks
* The automated profiling function shows some of the monitoring and analysis capabilities of the SDK.
```
cd demo_services/ovs_and_ryu/
son-profile -p ped_cpu.yml --mode passive --no-display
```
Grafana can be opened on the host: http://localhost:3000  (Grafana default login is admin, admin).
In the browser, Grafana shows the measured metrics.

If the X11 settings are correct, a plot figure will show the ongoing profiling measurements.
(After 30 secs the window will show up and will refreshed every 30 secs as ddefined in the `ped_cpu.yml` file)

#### Demo VM example services

* **ovs_and_ryu**: Openflow switch VNF (ovs) with a controller VNF (Ryu).
Check the deployment movie [on youtube](https://www.youtube.com/watch?v=J14mb79Fwmc&t=445s)

* **vEPC**: to illustrate the editor and validator tools, different versions of a vEPC service are demonstrated. The increased complexity of the service graphs shows the added value of a formal validation tool.
  * **vepc**: The normal vEPC service, with MME, HSS, SGW, PGW and one VDU per VNF
  * **vepc_scaled**: The scaled version of the vEPC, where the VNF (MME, SGW, PGW) is scaled out with multiple VDUs (including a load-balancer and a datastore). The scaled VNFs are seen in the validator web gui, when opening VDU view.
  * **vepc_scaled_mgmt**: A management network is added to the previous vEPC service, to show the increased complexity and difficulty for graph validation.
  * **vepc_error**: An error is introduced in the previous vEPC version, the errors/warnings are listed in the validator web gui.

* **vCDN**: This example service deploys a 3 pop topology.  The vCDN service consists out of a webserver and multiple vCaches (squid VNFs). The emulated service can be manipulated to deploy vCache VNFs closer to the users if needed.
This illustrates the SDK ability to:
  * Test different placement strategies
  * Manipulate the chaining (SFC) of the deployed service
  * Test different scaling strategies and monitor their effects
The scripts needed for the SSM/FSM (for service or VNF configuration or scaling can be tested this way)

Some slides on the vCDN service are included in `documentation/`.
Check the deployment movie [on youtube](https://youtu.be/n-On-yGdWJw)

The commands to be used for the vCDN service:
```
# deploy the test topology in the emulator (use a different terminal)
sudo python src/emuvim/examples/demo_topo_3pop_vcdn.py

# push the package for deployment (directly via the REST api)
cd /demo_services/vcdn
curl --fail -i -X POST -F package=@vcdn.son http://127.0.0.1:5000/packages
# or push from the editor at http://localhost:8080

# Optionally execute a profiling test for the vCache (squid) VNF
cd /demo_services/vcdn
sudo son-profile -p ped_vcdn.yml --mode passive --no-display

# configure the VNFs
cd /demo_services/vcdn
son-exec vCDN-SAP1 configure_sap1_start.sh
son-exec vCDN-SAP2 configure_sap2_start.sh

# start monitoring (check Grafana at: http://localhost:3000 )
sudo son-monitor msd -f msd2.yml

# check the dashboard at: http://localhost:5001/dashboard/index.html

# add another vCache VNF (squid2), closer to the vCDN-users2
source scale_out.sh

# check on the dashboard (refresh browser) if a second VNF (squid2) has been placed
# check in Grafana if traffic is routed to squid2

# scale back in
source scale_in.sh

# check on the dashboard if a second VNF (squid2) has been removed
# check in Grafana if traffic is routed back to squid1
```
