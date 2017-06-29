# SONATA Emulator to MANO Integration Demo

In this demo, we showcase an emulation platform that executes containerized network services in user-defined multi-PoP topologies. The platform does not only allow network service developers to locally test their services but also to connect real-world management and orchestration (MANO) solutions to the emulated PoPs. During our interactive demonstration we focus on the integration between the emulated infrastructure and state-of-the-art orchestration solutions like SONATA and OSM.

**Contact information:**<br>
Manuel Peuster<br>
Paderborn University<br>
[Website](https://cs.uni-paderborn.de/cn/person/?tx_upbperson_personsite%5BpersonId%5D=13271&tx_upbperson_personsite%5Bcontroller%5D=Person&cHash=bafec92c0ada0bdfe8af6e2ed99efb4e) | [GitHub](https://github.com/mpeuster)

## Background

### Demo Presentation

This demo was presented in IEEE NetSoft 2017 demo track, July 2017, Bologna, Italy:

* M. Peuster, S. Dräxler, H. Razzaghi, S. v. Rossem, W. Tavernier and H. Karl: [**A Flexible Multi-PoP Infrastructure Emulator for Carrier-grade MANO Systems**](https://cs.uni-paderborn.de/fileadmin/informatik/fg/cn/Publications_Conference_Paper/Publications_Conference_Paper_2017/peuster_netsoft_demo_paper_2017.pdf). In IEEE 3rd Conference on Network Softwarization (NetSoft) Demo Track. (2017)
* Demo Poster [download](https://github.com/mpeuster/son-tutorials/raw/master/upb-emulator-mano-integration-demo/doc/poster-sonata-emulator-integration-demo.pdf)
* Demo support slides [download](https://github.com/mpeuster/son-tutorials/raw/master/upb-emulator-mano-integration-demo/doc/sonata-emulator-integration-demo-slides.pptx) 

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

### YouTube Video(s)

The following demo shows the OSM part of this dem (falvor E):

* [SONATA Emulator OSM integration demo (IEEE NetSoft 2017)](TODO)

There are a couple more videos available that demonstrate the emulator in different usage scenarios (some videos show older software versions):

* Snort VNF example: https://youtu.be/nj5hTk1LLe4
* SONATA Y1 review demo: https://youtu.be/ZANz97pV9ao
* OSM integration tech-preview: https://youtu.be/8X2lpAbeLvM

## Demo

### Demonstration VM

There is a _ready-to-use_ demo VM that can be downloaded and used to perform this demo:

* [SONATA Emulator Integration Demo VM 2017 Download](http://www.peuster.de/SONATA/todo) (~20GB since it ships with OSM, and SONATA service platform pre-installed)

Import and start the downloaded VM using VirtualBox (see also: [Import VM to VirtualBox](https://docs.oracle.com/cd/E26217_01/E26796/html/qs-import-vm.html)).

```
Username: sonata
Password: sonata
```

#### VM Requirements

* 4 CPU cores
* 8 GB RAM
* 20GB free disk space
* `vboxnet0` @ `172.0.0.0/24` installed

### Storyboard

There are five different flavors and stories of this demo, pick one of them:

* (A) [HEAT-based service deployment](../upb-emulator-mano-integration-demo/doc/story_heat.md)
* (B) [SONATA service package w. emulator GK](https://github.com/mpeuster/son-tutorials/blob/master/upb-emulator-mano-integration-demo/doc/stroy_sonata_dk.md)
* (C) [SONATA service platform as MANO](../upb-emulator-mano-integration-demo/doc/story_sonata_sp.md)
* (D) [OSM as MANO (RO only)](../upb-emulator-mano-integration-demo/doc/story_osm.md)
* (E) [OSM as MANO (full)](../upb-emulator-mano-integration-demo/doc/story_osm_gui.md)

## Feedback

If you have feedback to this demo write to: `manuel (dot) peuster (a) upb (dot) de`. Thanks for your interest!
