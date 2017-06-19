# Containernet and SONATA Emulator Demo

This demo shows how to use Containernet or its extension MeDICINE (son-emu) to setup custom emulated networks that use Docker containers as compute instances, e.g., to run virtualized network functions (VNFs).

**Contact information:**<br>
Manuel Peuster<br>
Paderborn University<br>
[Website](https://cs.uni-paderborn.de/cn/person/?tx_upbperson_personsite%5BpersonId%5D=13271&tx_upbperson_personsite%5Bcontroller%5D=Person&cHash=bafec92c0ada0bdfe8af6e2ed99efb4e) | [GitHub](https://github.com/mpeuster)

## Background

### Containernet

Containernet is a Mininet fork that allows to use Docker containers as hosts in emulated networks. This enables interesting functionalities to built networking/cloud testbeds. The integration is done by subclassing the original Host class.

* [Containernet](https://github.com/containernet/containernet)
* [Mininet](http://mininet.org/)

### MeDICINE (son-emu)

The MeDICINE emulation platform was created to support network service developers to locally prototype and test complete network service chains in realistic end-to-end multi-PoP scenarios. It is part of SONATA's SDK where it is called _son-emu_. It allows the execution of real network functions, packaged as Docker containers, in emulated network topologies running locally on the network service developer's machine.

* [GitHub: son-emu](https://github.com/sonata-nfv/son-emu)
* [SONATA NFV Project](http://sonata-nfv.eu)

### Publications

* M. Peuster, H. Karl, and S. v. Rossem: **[MeDICINE: Rapid Prototyping of Production-Ready Network Services in Multi-PoP Environments](http://ieeexplore.ieee.org/document/7919490/)**. IEEE Conference on Network Function Virtualization and Software Defined Networks (NFV-SDN), Palo Alto, CA, USA, pp. 148-153. doi: 10.1109/NFV-SDN.2016.7919490. (2016)

* S. v. Rossem, W. Tavernier, M. Peuster, D. Colle, M. Pickavet and P. Demeester: **[Monitoring and debugging using an SDK for NFV-powered telecom applications](https://biblio.ugent.be/publication/8521281/file/8521284.pdf)**. IEEE Conference on Network Function Virtualization and Software Defined Networks (NFV-SDN), Palo Alto, CA, USA, Demo Session. (2016)

* M. Peuster, S. Dräxler, H. Razzaghi, S. v. Rossem, W. Tavernier and H. Karl: **A Flexible Multi-PoP Infrastructure Emulator for Carrier-grade MANO Systems**. In IEEE 3rd Conference on Network Softwarization (NetSoft) Demo Track . (2017) 

### YouTube Demos

There are a couple of YouTube videos available that demonstrate the emulator in different usage scenarios (some videos show older software versions):

* Snort VNF example: https://youtu.be/nj5hTk1LLe4
* SONATA Y1 review demo: https://youtu.be/ZANz97pV9ao
* OSM integration tech-preview: https://youtu.be/8X2lpAbeLvM

## Demonstration VM

There is a _ready-to-use_ demo VM that can be downloaded and used to perform this demo:

* [SONATA Emulator Demo VM 2017 Download](http://www.peuster.de/SONATA/sonata-emulator-demo-vm-2017.ova) (~4.1GB)

Import and start the downloaded VM using VirtualBox (see also: [Import VM to VirtualBox](https://docs.oracle.com/cd/E26217_01/E26796/html/qs-import-vm.html)).

```
Username: sonata
Password: sonata
```

## Containernet

### How to create a custom topology?

Containernet topologies are defined like Mininet topologies by using Python. An example topology that shows how multiple Docker containers are connected to a couple of switches and Mininet hosts is available in:

`~/demo/topologies/containernet_example1.py`

To open and watch it type:
`mousepad ~/demo/topologies/containernet_example1.py`

The following lines show how Docker containers are added to the topologies just like normal Mininet hosts are added.

```python
# add containers to topology
d1 = net.addDocker('d1', ip='10.0.0.251', dimage="ubuntu:trusty")
d2 = net.addDocker('d2', ip='10.0.0.252', dimage="ubuntu:trusty")

# connect containers to switches
net.addLink(d1, s1)
net.addLink(d2, s2)
```

It also possible to specify start commands, shared volumes, and resource constraints as shown [here](https://github.com/containernet/containernet/blob/master/examples/dockerhosts.py).

### How to run and use the custom topology?

To execute this network type:

`sudo python ~/demo/topologies/containernet_example1.py`

This starts the emulated network and brings you to Containernet's interactive CLI:

```
containernet>
```

You can now play around with the network by typing:

```
containernet> dump
containernet> d1 ifconfig
containernet> d2 ifconfig
containernet> d1 ping -c3 d2
containernet> d1 ping -c3 h1
containernet> h1 ls
containernet> d1 ls
```

Please see how the ping between `d1` and `d2` are delayed by `200ms` because of the emulated slow link between `s1` and `s2`. These commands show that you can use normal Mininet hosts `h1` and `h2` in the same network with Docker containers `d1` and `d2` and that they can communicate seamlessly with each other. You can also see that `h1 ls` lists you the file system of the host machine whereas `d1 ls` shows you the internal filesystem of the Docker container. Further `d2 ifconfig` shows you how multiple network interfaces are added to a single Docker container.

#### Directly interact with Docker containers

Even though the interactive CLI gives you a nice and easy way to interact with the running containers it has some limits. It is for example not possible to run interactive shell processes (like `top`) through the CLI. However, Containernet still allows its users to use the normal Docker API to interact with the running controllers. 

To directly connect to `d2` open **another terminal** window and type:

```
docker ps
docker attach mn.d2
<enter>
<enter>

root@d2> top
```

<small>(Note 1: every Containernet controlled container is pre-fixed with `mn.` do distinguish them from normally managed Docker containers)</small>

<small>(Note 2: To detach from the container, switch to the Containernet terminal and type `containernet> exit`. Do not directly detach from the container to not confuse Containernet)</small>

Now you can stop containernet with:
```
containernet> exit
```

## son-emu

### How to create a son-emu topology?

SONATA's emulator `son-emu` uses the exact same mechanisms to define topologies like Containernet does but a different abstraction level. Instead of defining switches and hosts, a topology defines switches and data centers (also called PoPs: point of presence) in which compute instances can be started at runtime. In such an topology the networking part of each data center is simplified with a single SDN switch (big switch abstraction). For more details see the MeDICINE paper in the publications section.

An simple example topology with two data centers (PoPs) and an intermediate switch is available in the demo VM:

`mousepad ~/demo/topologies/son-emu_example1.py`

The following lines show how the topology file describes emulated data centers, interconnects them and adds a REST API endpoint to them.

```python
    # create emulated data centers
    dc1 = net.addDatacenter("dc1")
    dc2 = net.addDatacenter("dc2")
    # add an intermediate switch
    s1 = net.addSwitch("s1")
    # interconnect data centers
    net.addLink(dc1, s1, delay="10ms")
    net.addLink(dc2, s1, delay="20ms")

    # add REST control endpoints to each datacenter (to be used with son-emu-cli)
    rapi1 = RestApiEndpoint("0.0.0.0", 5001)
    rapi1.connectDCNetwork(net)
    rapi1.connectDatacenter(dc1)
    rapi1.connectDatacenter(dc2)
    rapi1.start()
```

### How to run and use the son-emu topology?

To start this topology do:

`sudo python ~/demo/topologies/son-emu_example1.py`

This will bring you again to Containernet's interactive CLI:

```
containernet>
```

However, no hosts nor containers are started at this point and need to be _instantiated through APIs_ just like in a real-world cloud environment, as described in the following sections.

### How to start compute instances in the son-emu topology?

To interact with the running emulator instance, use a **second terminal window** and the CLI tool called `son-emu-cli` as follows:

```sh
# list emulated data centers
son-emu-cli datacenter list
# output
+---------+-----------------+----------+----------------+--------------------+
| Label   | Internal Name   | Switch   |   # Containers |   # Metadata Items |
+=========+=================+==========+================+====================+
| dc2     | dc2             | dc2.s1   |              0 |                  0 |
+---------+-----------------+----------+----------------+--------------------+
| dc1     | dc1             | dc1.s1   |              0 |                  0 |
+---------+-----------------+----------+----------------+--------------------+

# start "vnf1" in datacenter "dc1"
son-emu-cli compute start -d dc1 -n vnf1 --image ubuntu:trusty
# start "vnf2" in datacenter "dc2"
son-emu-cli compute start -d dc2 -n vnf2 --image ubuntu:trusty

# list running compute instances
son-emu-cli compute list
# output
+--------------+-------------+---------------+------------------+-------------------------+
| Datacenter   | Container   | Image         | Interface list   | Datacenter interfaces   |
+==============+=============+===============+==================+=========================+
| dc2          | vnf2        | ubuntu:trusty | vnf2-eth0        | dc2.s1-eth2             |
+--------------+-------------+---------------+------------------+-------------------------+
| dc1          | vnf1        | ubuntu:trusty | vnf1-eth0        | dc1.s1-eth2             |
+--------------+-------------+---------------+------------------+-------------------------+
```

As you can see, the `son-emu-cli compute` CLI is inspired by cloud client interfaces, like OpenStack Nova. You can specify the used images with the `--image` flag followed by a Docker image identifier URL.

Note: All Docker images required for this demo are already pre-build and available in the demo VM. List them using `docker images`.

You can now interact with the running containers like in the previous Containernet examples. You can for example switch to the Containernet terminal and type:

```
# list the emulated network and compute instances
containernet> dump
# check connectivity
containernet> vnf1 ping -c3 vnf2
```

The ping between both VNFs works because we configured our topology to run all involved switches as layer 2 learning switches (`enable_learning=True`). Thus, the emulator's build-in chaining functionality was not required for communication between VNFs.

```python
net = DCNetwork(controller=RemoteController, monitor=False, enable_learning=True)
```

Now you can stop the emulator with:
```
containernet> exit
```

### How to use build-in chaining?

We now use a different topology in which the automatic learning behavior of the switches is not enabled to demonstrate the emulator's chaining API.

Start another topology in which the learning switch functionality is disabled (`enable_learning=False`):

`sudo python ~/demo/topologies/son-emu_example2.py`

We again start some compute instances:

```sh
# start "vnf1" in datacenter "dc1"
son-emu-cli compute start -d dc1 -n vnf1
# start "vnf2" in datacenter "dc2"
son-emu-cli compute start -d dc2 -n vnf2
# start "vnf3" in datacenter "dc1"
son-emu-cli compute start -d dc1 -n vnf3
```

Now, if we try a ping, we see that the instances cannot communicate with each other, because of the disabled learning switch and the missing chain configuration:

```sh
containernet> vnf1 ping -c3 vnf2
# output
--- 10.0.0.4 ping statistics ---
3 packets transmitted, 0 received, +3 errors, 100% packet loss, time 2034ms
```

To change this we have to define a chain between the two running compute instances. This can be done with the `son-emu-cli` tool with the following command that specifies a _bidirectional_ `(-b)`chain between source `-src vnf1:vnf1-eth0` and destination `-dst vnf2:vnf2-eth0`:

```sh
son-emu-cli network add -b -src vnf1:vnf1-eth0 -dst vnf2:vnf2-eth0
```

Once the command is executed we can ping again and see that communication is now possible between `vnf1` and `vnf2`. However, communication between `vnf1` and `vnf3` is still not possible due to the missing chain between these compute instances.

```sh
containernet> vnf1 ping -c3 vnf2
# output
--- 10.0.0.4 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 62.071/86.070/133.708/33.686 ms

containernet>  vnf1 ping -c3 vnf3
# output
--- 10.0.0.6 ping statistics ---
3 packets transmitted, 0 received, +3 errors, 100% packet loss, time 2050ms
```

Now you can stop the emulator with:
```
containernet> exit
```

## son-emu and SONATA service package

Finally, we want to demonstrate how the emulator is used within the [SONATA NFV](http://sonata-nfv.eu) eco system, in which complex network services consisting of multiple chained VNFs are defined using the SONATA description format and are packed to so called _network service packages_ which are then uploaded to and deployed on the SONATA NFV platform or on the emulator.

### Add a SONATA gatekeeper interface to your topology

To allow the emulator to deploy SONATA service packages, we need to add an additional interface to the emulated data centers by extending the topology file.

A prepared topology can be found in:

`mousepad ~/demo/topologies/son-emu_example3.py`

In this topology, the `SonataDummyGatekeeperEndpoint ` is added to both emulated data centers with the following lines:

```python
sdkg1 = SonataDummyGatekeeperEndpoint("0.0.0.0", 5000, deploy_sap=False)
sdkg1.connectDatacenter(dc1)
sdkg1.connectDatacenter(dc2)
sdkg1.start()
```

To start the topology do:

`sudo python ~/demo/topologies/son-emu_example3.py`

### Create a SONATA service package using the SONATA SDK (son-cli)

Now, after the emulator is running, we need to prepare a SONATA service package to be uploaded to the emulator. We do this using SONATA's SDK tools called [son-cli](https://github.com/sonata-nfv/son-cli).

A prepared SONATA demo service project with a single Snort IDS VNF can be found in: `~/demo/sonata-demo-service/`.

The service consists of three descriptors: The project descriptor `project.yml`, the network service descriptor `snort-nsd.yml`, and the VNF descriptor `snort-vnfd.yml`:

```
sonata@demo:~$ tree demo/sonata-demo-service/
demo/sonata-demo-service/
├── project.yml
└── sources
    ├── nsd
    │   └── snort-nsd.yml
    └── vnf
        └── snort-vnf
            └── snort-vnfd.yml
```

You can check the content and structure of each of the descriptors using a text editor:

```
mousepad demo/sonata-demo-service/sources/nsd/snort-nsd.yml
```

Note: All required Docker images used by this services are already pre-build in the demo VM and can be listed with `docker images`.

#### Packaging

To create a SONATA service package based on the given SONATA network service project, the `son-package` tool can be used. This tool collects all dependencies and creates a single package file (`*.son`) which defines the complete network service.

Packaging the demo project:

```
son-package --project demo/sonata-demo-service -n sonata-demo-service

# final output:
File: /home/sonata/sonata-demo-service.son
MD5: 637da0d6b06d16320f363df9e9c1f6a3
```

The outputs of this command show you how the service is packaged and how the descriptors are validated. The final service package is stored in `/home/sonata/sonata-demo-service.son`.

### Deploy the created service package on the emulator

The previously created service package can now be deployed on the still running emulator (`sudo python ~/demo/topologies/son-emu_example3.py`) with the following two steps:

#### On-boarding

First, the service package needs to be uploaded to the emulator (this is also called on-boarding) by using the `son-access` tool which is part of `son-cli` and allows to interact with a remote SONATA platform or an emulator instance that offers a SONATA Gatekeeper interface.

```sh
# upload (on-board) the package
son-access push --upload sonata-demo-service.son

# output
Upload succeeded (201): '{\n    "error": null, \n    "service_uuid": "9793adc0-688a-445f-b014-edf79eebf0fb", \n    "sha1": "90ea855a5a6d4ce78674df246fe8a46ff7cfdc40", \n    "size": 3652\n}\n'
```

Please copy the `service_uuid` since it is required in the next step to instantiate the uploaded service.

#### Instantiation

```sh
# trigger the instantiation of the previously on-boarded service
son-access push --deploy <insert service uuid from last step here>
```

After this, the VNF container should be running in the emulator and we can play around with it like described in the following steps. It was started by the SONATA Gatekeeper interface which also decided in which data center the VNF was placed. The default placement equally distributes the VNFs across all availabe data centers. The algorithm can be found and modified [here](https://github.com/sonata-nfv/son-emu/blob/master/src/emuvim/api/sonata/dummygatekeeper.py#L867).

### Check the running SONATA service

We first deploy two additional containers (a `client` and a `server`) to check if the SONATA service works like expected. The final deployment will look as follows:

```
+--------+     +-----------+     +--------+
| client <-----> snort vnf <-----> server |
+--------+     +-----------+     +--------+
```

We deploy the additional containers using the `son-emu-cli` tool:

```sh
# start additional containers with a image that contains some test tools
son-emu-cli compute start -d dc1 -n client -i sonatanfv/sonata-iperf3-vnf
son-emu-cli compute start -d dc1 -n server -i sonatanfv/sonata-iperf3-vnf

# setup chain
son-emu-cli network add -b -src client:client-eth0 -dst snort_vnf:input
son-emu-cli network add -b -src server:server-eth0 -dst snort_vnf:output

# check the state of the overall deployment
son-emu-cli compute list

# output
+--------------+-------------+--------------------------------+-------------------+-------------------------------------+
| Datacenter   | Container   | Image                          | Interface list    | Datacenter interfaces               |
+==============+=============+================================+===================+=====================================+
| dc2          | snort_vnf   | sonatanfv/sonata-snort-ids-vnf | mgmt,input,output | dc2.s1-eth2,dc2.s1-eth3,dc2.s1-eth4 |
+--------------+-------------+--------------------------------+-------------------+-------------------------------------+
| dc1          | client      | sonatanfv/sonata-iperf3-vnf    | client-eth0       | dc1.s1-eth2                         |
+--------------+-------------+--------------------------------+-------------------+-------------------------------------+
| dc1          | server      | sonatanfv/sonata-iperf3-vnf    | server-eth0       | dc1.s1-eth3                         |
+--------------+-------------+--------------------------------+-------------------+-------------------------------------+
```

As you can see, the VNF from the service package (`snort_vnf `) as well as our additional test containers are up and running.

Finally we want to send some traffic through the Snort VNF. This can be done as follows:

```sh
# send some pings from the client through the VNF to the server
containernet> client ping -c2 server

# check if our Snort IDS VNF inspects the ping packets
containernet> snort_vnf cat /snort-logs/10.0.0.8/ICMP_ECHO_REPLY

# output
...
[**] Ping! [**]
06/12-10:35:44.289279 10.0.0.8 -> 10.0.0.6
ICMP TTL:64 TOS:0x0 ID:39656 IpLen:20 DgmLen:84
Type:0  Code:0  ID:43  Seq:8  ECHO REPLY
=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+

[**] Ping! [**]
06/12-10:35:45.292619 10.0.0.8 -> 10.0.0.6
ICMP TTL:64 TOS:0x0 ID:39851 IpLen:20 DgmLen:84
Type:0  Code:0  ID:43  Seq:9  ECHO REPLY
=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
...
```

Now lets check if our Snort IDS logs SSH connection attempts:

```
# check if Snort has logged the connection attempt?
containernet> snort_vnf cat /snort-logs/alert

# output
<empty>

# try to connect to the server via SSH:
containernet> client ssh server

# output
ssh: connect to host 10.0.0.8 port 22: Connection refused

# check if Snort has logged the connection attempt?
containernet> snort_vnf cat /snort-logs/alert

# output
06/12-10:40:32.099371  [**] [1:9999998:1] Attention! Some bad guy wants to SSH into your network (tcp:22)! [**] [Priority: 0] {TCP} 10.0.0.6:53148 -> 10.0.0.8:22
```

Perfect! Our VNF works!

### One more thing

The emulator provides a web-based dashboard that shows the outputs of `son-emu-cli compute list` and helps to visualize its state during demonstrations. You can open this dashboard by clicking **Emulator Dashboard** on the VM's Desktop while the emulator is running.

### That's it!

Now you can stop the emulator with:
```
containernet> exit
```
