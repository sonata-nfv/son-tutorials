#!/bin/bash
ovs-vsctl add-br br-eth0
sleep 5
ovs-vsctl add-port br-eth0 em1
sleep 5
ifconfig br-eth0 up
sleep 5
ip link set br-eth0 promisc on
sleep 5
ip link add proxy-br-eth1 type veth peer name eth1-br-proxy
sleep 5
ip link add proxy-br-ex type veth peer name ex-br-proxy
sleep 5
ovs-vsctl add-br br-eth1
sleep 5
ovs-vsctl add-br br-ex
sleep 5
ovs-vsctl add-port br-eth1 eth1-br-proxy
sleep 5
ovs-vsctl add-port br-ex ex-br-proxy
sleep 5
ovs-vsctl add-port br-eth0 proxy-br-eth1
sleep 5
ovs-vsctl add-port br-eth0 proxy-br-ex
sleep 5
ip link set eth1-br-proxy up promisc on
sleep 5
ip link set ex-br-proxy up promisc on
sleep 5
ip link set proxy-br-eth1 up promisc on
sleep 5
ip link set proxy-br-ex up promisc on

