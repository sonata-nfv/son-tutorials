#!/bin/bash

set -e

docker build -t empty-vnf-ubuntu-img -f empty-vnf/Dockerfile empty-vnf
