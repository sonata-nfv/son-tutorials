#! /bin/bash

##### scaling FSM ########################
#add new squid
son-emu-cli compute start -d dc2 -n squid2 -i squid-vnf --net '(id=port0,ip=10.20.0.4/24),(id=port1,ip=10.20.1.3/24)' 
son-emu-cli network addLAN -src squid2:port0 -vl 1
son-emu-cli network addLAN -src squid2:port1 -vl 2
son-exec vCDN-SAP2 configure_sap2_squid2.sh
#######################################

