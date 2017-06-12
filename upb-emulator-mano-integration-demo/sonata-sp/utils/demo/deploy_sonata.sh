#!/bin/bash

# service platform configuration
HOST_IP="172.0.0.199"

# VIM configuration
VIM_1_ENDPOINT="172.0.0.199:6001"
VIM_1_USER="username"
VIM_1_PASSWORD="password"
VIM_1_TENANT="tenant"
VIM_1_TENANT_EXT_NET="none"
VIM_1_TENANT_EXT_ROUTER="none"


# clean
docker rm -f son-pluginmanager
docker rm -f son-sp-infrabstract

### son-mano-framework
docker run -d --name son-pluginmanager -p 8001:8001 -e mongo_host=$HOST_IP -e broker_host=amqp://guest:guest@$HOST_IP:5672/%2F sonatanfv/pluginmanager /bin/bash /delayedstart.sh 10 son-mano-pluginmanager

sleep 60

docker run -d --name specificmanagerregistry --link son-broker:broker -e broker_name=son-broker,broker -e broker_host=amqp://guest:guest@$HOST_IP:5672/%2F -v '/var/run/docker.sock:/var/run/docker.sock'  sonatanfv/specificmanagerregistry



### son-sp-infrabstract
docker run -d --name son-sp-infrabstract -e broker_host=$HOST_IP -e broker_uri=amqp://guest:guest@$HOST_IP:5672/%2F -e repo_host=$HOST_IP -e repo_port=5432 -e repo_user=sonatatest -e repo_pass=sonata mpeuster/son-sp-infra /docker-entrypoint.sh

echo ""
echo "SONATA Pluginmanager, SONATA SP Infrastructure Adaptor started."

# wait
#while ! docker exec -t son-postgres psql -h localhost -U postgres -d vimregistry -c "SELECT * FROM VIM"; do
#  sleep 2 && echo -n .; # waiting for table creation
#done;

#while ! docker exec -t son-postgres psql -h localhost -U postgres -d vimregistry -c "SELECT * FROM LINK_VIM"; do
#  sleep 2 && echo -n .; # waiting for table creation
#done;

# ADD THE VIMs
## PoP#1
#docker exec -t son-postgres psql -h localhost -U postgres -d vimregistry -c "INSERT INTO VIM (uuid, type, vendor, endpoint, username, tenant, tenant_ext_net, tenant_ext_router, pass, authkey) VALUES ('1111-22222222-33333333-4444', 'compute', 'Heat', '$VIM_1_ENDPOINT', '$VIM_1_USER', '$VIM_1_TENANT', '$VIM_1_TENANT_EXT_NET', '$VIM_1_TENANT_EXT_ROUTER', '$VIM_1_PASSWORD', null);"
