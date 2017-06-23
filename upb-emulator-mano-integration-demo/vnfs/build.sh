#!/bin/bash

# CI entry point
# automatically build VNF containers
# (later we might also automatically build VM images that run these containers)
#
set -e

#docker build -t $target_repo/p2-mp -f p2-mp/Dockerfile p2-mp
docker build -t l4fw-socat-img -f p2-l4fw-socat/Dockerfile p2-l4fw-socat
docker build -t l4fw-redir-img -f p2-l4fw-redir/Dockerfile p2-l4fw-redir
docker build -t http-apache-img -f p2-apache/Dockerfile p2-apache
docker build -t http-nginx-img -f p2-nginx/Dockerfile p2-nginx
docker build -t proxy-squid-img -f p2-squid/Dockerfile p2-squid

# builds for sonata integration
docker build -t eu.sonata-nfv_apache-vnf_0.1_1 -f p2-apache/Dockerfile p2-apache
docker build -t eu.sonata-nfv_squid-vnf_0.1_1 -f p2-squid/Dockerfile p2-squid
docker build -t eu.sonata-nfv_socat-vnf_0.1_1 -f p2-l4fw-socat/Dockerfile p2-l4fw-socat
