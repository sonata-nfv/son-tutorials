#!/usr/bin/python

"""
This example shows how to create a simple network and
how to connect docker containers (based on existing images)
to it.
"""

from mininet.net import Containernet
from mininet.node import Controller, Docker
from mininet.cli import CLI
from mininet.log import setLogLevel, info
from mininet.link import TCLink, Link


def topology():

    "Create a network with some docker containers acting as hosts."

    net = Containernet(controller=Controller)

    info('*** Adding controller\n')
    net.addController('c0')

    info('*** Adding normal Mininet hosts\n')
    h1 = net.addHost('h1')
    h2 = net.addHost('h2')

    info('*** Adding docker containers\n')
    d1 = net.addDocker('d1', ip='10.0.0.251', dimage="ubuntu:trusty")
    d2 = net.addDocker('d2', ip='10.0.0.252', dimage="ubuntu:trusty")

    info('*** Adding switch\n')
    s1 = net.addSwitch('s1')
    s2 = net.addSwitch('s2')
    s3 = net.addSwitch('s3')

    info('*** Creating links\n')
    net.addLink(h1, s1)
    net.addLink(h2, s2)
    net.addLink(d1, s1)
    net.addLink(d2, s2)
    net.addLink(s1, s2, cls=TCLink, delay="100ms", bw=1)

    # we can even add multiple interfaces to a single docker container
    net.addLink(d2, s3, params1={"ip": "11.0.0.254/24"})

    info('*** Starting network\n')
    net.start()

    # run a short test
    net.ping([d1, d2])

    info('*** Running CLI\n')
    CLI(net)  # wait for user input

    info('*** Stopping network')
    net.stop()

if __name__ == '__main__':
    setLogLevel('info')
    topology()
