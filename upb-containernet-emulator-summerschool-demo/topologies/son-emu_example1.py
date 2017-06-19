"""
A simple topology with two PoPs.

        (dc1) <<-->> s1 <<-->> (dc2)
"""

import logging
from mininet.log import setLogLevel
from emuvim.dcemulator.net import DCNetwork
from emuvim.api.rest.rest_api_endpoint import RestApiEndpoint
from emuvim.api.sonata import SonataDummyGatekeeperEndpoint
from mininet.node import RemoteController

logging.basicConfig(level=logging.INFO)


def create_topology1():
    # create topology
    net = DCNetwork(controller=RemoteController, monitor=False, enable_learning=True)
    # add datecenters
    dc1 = net.addDatacenter("dc1")
    dc2 = net.addDatacenter("dc2")
    # add some intermediate switch
    s1 = net.addSwitch("s1")
    # connect data centers
    net.addLink(dc1, s1, delay="10ms")
    net.addLink(dc2, s1, delay="20ms")

    # add REST control endpoints to each datacenter (to be used with son-emu-cli)
    rapi1 = RestApiEndpoint("0.0.0.0", 5001)
    rapi1.connectDCNetwork(net)
    rapi1.connectDatacenter(dc1)
    rapi1.connectDatacenter(dc2)
    rapi1.start()

    # start the emulation platform
    net.start()
    net.CLI()
    net.stop()


def main():
    setLogLevel('info')  # set Mininet loglevel
    create_topology1()


if __name__ == '__main__':
    main()
