#!/bin/bash

set -e
set -x

if [ "$(id -u)" != "0" ]; then
	echo "Sorry, you are not root."
	exit 1
fi

# Checkout the repos

if [ ! -d "son-sp-infrabstract" ]; then
  git clone https://github.com/DarioValocchi/son-sp-infrabstract
fi

if [ ! -d "son-mano-framework" ]; then
  git clone https://github.com/tsoenen/son-mano-framework
fi

# Update the repos

cd son-sp-infrabstract
# git pull origin master

cd ../son-mano-framework
# git pull origin master

cd ..

# Run the rabbit msgbus
docker run -d -p 8080:15672 --name son-broker rabbitmq:3-management
#while ! nc -z localhost 5672; do
#  sleep 1 && echo -n .; # waiting for rabbitmq
#done;

sleep 2
# The MongoDB:

docker run -d -p 27017:27017 --name mongo mongo
while ! nc -z localhost 27017; do
  sleep 1 && echo -n .; # waiting for mongo
done;

# The Postgresdb:

docker run -d -p 5432:5432 --name son-postgres -e POSTGRES_DB=vimregistry -e POSTGRES_USER=sonatatest -e POSTGRES_PASSWORD=sonata ntboes/postgres-uuid
while ! nc -z localhost 5432; do
  sleep 1 && echo -n .; # waiting for postgres
done;

#Build containers
cd ./son-mano-framework

docker build -t registry.sonata-nfv.eu:5000/pluginmanager -f son-mano-pluginmanager/Dockerfile .

docker build -t registry.sonata-nfv.eu:5000/servicelifecyclemanagement -f plugins/son-mano-service-lifecycle-management/Dockerfile .

docker build -t registry.sonata-nfv.eu:5000/specificmanagerregistry -f son-mano-specificmanager/son-mano-specific-manager-registry/Dockerfile .

docker build -t registry.sonata-nfv.eu:5000/placementexecutive -f plugins/son-mano-placement-executive/Dockerfile .

cd ../son-sp-infrabstract/vim-adaptor

docker build -t registry.sonata-nfv.eu:5000/son-sp-infrabstract .


#The Plugin Manager (build from the root of son-mano-framework repo):
cd ../

screen -d -S pluginManager -m docker run --name pluginmanager -p 8001:8001 --link mongo --link son-broker -e mongo_host=mongo -e broker_host=amqp://guest:guest@son-broker:5672/%2F registry.sonata-nfv.eu:5000/pluginmanager

sleep 1

screen -d -S SLM -m docker run --name servicelifecyclemanagement --link son-broker -e broker_host=amqp://guest:guest@son-broker:5672/%2F registry.sonata-nfv.eu:5000/servicelifecyclemanagement

screen -d -S SMR -m docker run -it --name specificmanagerregistry --link son-broker:broker -e broker_name=son-broker,broker -v '/var/run/docker.sock:/var/run/docker.sock' -e broker_host=amqp://guest:guest@son-broker:5672/%2F registry.sonata-nfv.eu:5000/specificmanagerregistry

screen -d -S PEX -m docker run --name placementexecutive --link son-broker -e broker_host=amqp://guest:guest@son-broker:5672/%2F registry.sonata-nfv.eu:5000/placementexecutive

screen -d -S IA -m docker run -it --name son-sp-infrabstract --link son-broker --link son-postgres -e broker_host=son-broker -e broker_uri=amqp://guest:guest@son-broker:5672/%2F -e repo_host=son-postgres -e repo_port=5432 -e repo_user=sonatatest -e repo_pass=sonata registry.sonata-nfv.eu:5000/son-sp-infrabstract /docker-entrypoint.sh

while ! docker exec -t son-postgres psql -h localhost -U postgres -d vimregistry -c "SELECT * FROM VIM"; do
  sleep 2 && echo -n .; # waiting for table creation
done;

while ! docker exec -t son-postgres psql -h localhost -U postgres -d vimregistry -c "SELECT * FROM LINK_VIM"; do
  sleep 2 && echo -n .; # waiting for table creation
done;

# # Add the VIM(s)
# ## PoP#200
# docker exec -t son-postgres psql -h localhost -U sonatatest -d vimregistry -c "INSERT INTO VIM (UUID, TYPE, VENDOR, ENDPOINT, USERNAME, CONFIGURATION, CITY, COUNTRY, PASS, AUTHKEY) VALUES ('1111-22222222-33333333-4444', 'compute', 'Heat', '172.18.107.49', 'admin', '{"tenant_ext_net":"public","tenant":"06215c07ce5f462a897b5a820eecdbbd","tenant_ext_router":"router1"}', 'Ghent', 'Belgium', 'sonata', null);"
# docker exec -t son-postgres psql -h localhost -U sonatatest -d vimregistry -c "INSERT INTO VIM (UUID, TYPE, VENDOR, ENDPOINT, USERNAME, CONFIGURATION, CITY, COUNTRY, PASS, AUTHKEY) VALUES ('aaaa-bbbbbbbb-cccccccc-dddd', 'network', 'ovs', '172.18.107.49', 'admin', '{"compute_uuid":"1111-22222222-33333333-4444"}', 'Ghent', 'Belgiun', 'sonata', null);"
# docker exec -t son-postgres psql -h localhost -U sonatatest -d vimregistry -c "INSERT INTO LINK_VIM (COMPUTE_UUID, NETWORKING_UUID) VALUES ('1111-22222222-33333333-4444', 'aaaa-bbbbbbbb-cccccccc-dddd');"

# Add the VIM(s)
# PoP#200
docker exec -t son-postgres psql -h localhost -U sonatatest -d vimregistry -c "INSERT INTO VIM (UUID, TYPE, VENDOR, ENDPOINT, USERNAME, CONFIGURATION, CITY, COUNTRY, PASS, AUTHKEY) VALUES ('1111-22222222-33333333-4444', 'compute', 'Heat', '10.100.32.200', 'sonata.dem', '{"tenant_ext_net":"53d43a3e-8c86-48e6-b1cb-f1f2c48833de","tenant":"admin","tenant_ext_router":"e8cdd5c7-191f-4215-83f3-53ee1113db86"}', 'Athens', 'Greece', 's0nata.d3m', null);"
docker exec -t son-postgres psql -h localhost -U sonatatest -d vimregistry -c "INSERT INTO VIM (UUID, TYPE, VENDOR, ENDPOINT, USERNAME, CONFIGURATION, CITY, COUNTRY, PASS, AUTHKEY) VALUES ('aaaa-bbbbbbbb-cccccccc-dddd', 'network', 'ovs', '10.100.32.200', 'sonata.dem', '{"compute_uuid":"1111-22222222-33333333-4444"}', 'Athens', 'Greece', 's0nata.d3m', null);"
docker exec -t son-postgres psql -h localhost -U sonatatest -d vimregistry -c "INSERT INTO LINK_VIM (COMPUTE_UUID, NETWORKING_UUID) VALUES ('1111-22222222-33333333-4444', 'aaaa-bbbbbbbb-cccccccc-dddd');"

# ## PoP#10
# docker exec -t son-postgres psql -h localhost -U sonatatest -d vimregistry -c "INSERT INTO VIM (UUID, TYPE, VENDOR, ENDPOINT, USERNAME, CONFIGURATION, CITY, COUNTRY, PASS, AUTHKEY) VALUES ('5555-66666666-77777777-8888', 'compute', 'Heat', '10.100.32.10', 'sonata.dem', '{"tenant_ext_router":"2c2a8b09-b746-47de-b0ce-dce5fa242c7e", "tenant_ext_net":"12bf4db8-0131-4322-bd22-0b1ad8333748","tenant":"sonata.dem"}', 'Athens', 'Greece', 's0n@t@.dem', null);"
# docker exec -t son-postgres psql -h localhost -U sonatatest -d vimregistry -c "INSERT INTO VIM (UUID, TYPE, VENDOR, ENDPOINT, USERNAME, CONFIGURATION, CITY, COUNTRY, PASS, AUTHKEY) VALUES ('eeee-ffffffff-gggggggg-hhhh', 'network', 'ovs', '10.100.32.10', 'sonata.dem', '{"compute_uuid":"5555-66666666-77777777-8888"}', 'Athens', 'Greece', 's0n@t@.dem', null);"
# docker exec -t son-postgres psql -h localhost -U sonatatest -d vimregistry -c "INSERT INTO LINK_VIM (COMPUTE_UUID, NETWORKING_UUID) VALUES ('5555-66666666-77777777-8888', 'eeee-ffffffff-gggggggg-hhhh');"

sleep 1

docker ps 


#docker kill $(docker ps -q)

#docker rm $(docker ps -a -q)
