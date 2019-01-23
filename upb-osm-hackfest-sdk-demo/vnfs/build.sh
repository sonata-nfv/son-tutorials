#!/bin/bash

# CI entry point
# automatically build VNF containers
# (later we might also automatically build VM images that run these containers)
#
set -e

docker build -t l4fw-socat-img -f l4fw-socat/Dockerfile l4fw-socat
docker build -t http-apache-img -f http-apache/Dockerfile http-apache
docker build -t proxy-squid-img -f proxy-squid/Dockerfile proxy-squid

