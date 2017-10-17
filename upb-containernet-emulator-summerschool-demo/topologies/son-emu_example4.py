"""
A simple topology with two PoPs.

        (dc1) <<-->> s1 <<-->> (dc2)
"""

import logging
from mininet.log import setLogLevel
from emuvim.dcemulator.net import DCNetwork
from emuvim.api.rest.rest_api_endpoint import RestApiEndpoint
from emuvim.api.openstack.openstack_api_endpoint import OpenstackApiEndpoint
from mininet.node import RemoteController

logging.basicConfig(level=logging.INFO)


def create_topology1():
    # create topology
    net = DCNetwork(controller=RemoteController, monitor=False, enable_learning=True)
    # add datecenters
    dc1 = net.addDatacenter("dc1")

    # add REST control endpoints to datacenter (to be used with son-emu-cli)
    rapi1 = RestApiEndpoint("0.0.0.0", 5001)
    rapi1.connectDCNetwork(net)
    rapi1.connectDatacenter(dc1)
    rapi1.start()
    
    # add OpenStack/like interface endpoints to dc1
    api1 = OpenstackApiEndpoint("0.0.0.0", 6001)
    # connect PoPs
    api1.connect_datacenter(dc1)
    # connect network
    api1.connect_dc_network(net)
    # start
    api1.start()

    # start the emulation platform
    net.start()
    net.CLI()
    net.stop()


def main():
    setLogLevel('info')  # set Mininet loglevel
    create_topology1()


if __name__ == '__main__':
    main()
    
    
    
    
    


