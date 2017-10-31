FROM python:slim
MAINTAINER steven.vanrossem@intec.ugent.be

RUN	apt-get update && apt-get install -y \
	net-tools \
	iproute \
	inetutils-ping \
        ethtool \
	curl


ADD start.sh start.sh
RUN chmod +x start.sh

WORKDIR /

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt


ADD http_proxy_setting /http_proxy_setting
RUN chmod +rwx http_proxy_setting

# set entry point for emulator gatekeeper
ENV SON_EMU_CMD "./start.sh"

ADD squid_client.py squid_client.py
RUN chmod +x squid_client.py

CMD /bin/bash
