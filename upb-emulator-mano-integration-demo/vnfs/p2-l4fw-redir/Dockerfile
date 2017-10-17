FROM ubuntu:xenial
MAINTAINER manuel.peuster@uni-paderborn.de

# define interface names (should be the same as in VNFD)
ENV IFIN input
ENV IFOUT output

# configure layer 4 forwarding
ENV FW_IN_PORT 5202
ENV FW_OUT_ADDR 11.0.0.2
ENV FW_OUT_PORT 5201

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y -q \
	net-tools \
	iproute \
	inetutils-ping \
	iptables \
	redir

ADD start.sh start.sh
RUN chmod +x start.sh
ADD stop.sh stop.sh
RUN chmod +x stop.sh

WORKDIR /

# normal entry point
CMD /bin/bash
