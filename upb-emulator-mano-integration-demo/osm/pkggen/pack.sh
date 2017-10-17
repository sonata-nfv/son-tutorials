#!/bin/bash

./generate_descriptor_pkg.sh -t vnfd -N http
./generate_descriptor_pkg.sh -t vnfd -N l4fw
./generate_descriptor_pkg.sh -t vnfd -N proxy

./generate_descriptor_pkg.sh -t nsd -N demo_nsd
