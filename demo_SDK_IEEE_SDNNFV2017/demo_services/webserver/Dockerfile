FROM python:slim
MAINTAINER steven.vanrossem@intec.ugent.be

RUN	apt-get update && apt-get install -y \
	net-tools \
	iproute \
	inetutils-ping \
        ethtool


ADD start.sh start.sh
RUN chmod +x start.sh

WORKDIR /
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# set entry point for emulator gatekeeper
ENV SON_EMU_CMD "./start.sh"

ADD web_server.py web_server.py
RUN chmod +x web_server.py

CMD /bin/bash
