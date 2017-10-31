#! /bin/bash

##### scaling FSM #######################
#remove new squid
son-exec vCDN-SAP2 configure_sap2_squid1.sh
son-emu-cli compute stop -d dc2 -n squid2 

#######################################
