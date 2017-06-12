#!/bin/bash
#
# start the SONATA SP (all its containers)
#
set -e
set -x

# service platform configuration
HOST_IP="131.234.31.55"

# VIM configuration
VIM_1_ENDPOINT="sonata-emulator.cs.upb.de:6001"
VIM_1_USER="username"
VIM_1_PASSWORD="password"
VIM_1_TENANT="tenant"
VIM_1_TENANT_EXT_NET="none"
VIM_1_TENANT_EXT_ROUTER="none"


### databases
# postgres
docker run -d -p 5432:5432 --name son-postgres -e POSTGRES_DB=gatekeeper -e POSTGRES_USER=sonatatest -e POSTGRES_PASSWORD=sonata ntboes/postgres-uuid
while ! nc -z $HOST_IP 5432; do
  sleep 1 && echo -n .; # waiting for postgres
done;
# mongo
docker run -d -p 27017:27017 --name son-mongo mongo
while ! nc -z $HOST_IP 27017; do
  sleep 1 && echo -n .; # waiting for mongo
done;
# mysql
docker run -d --name son-monitor-mysql -e MYSQL_ROOT_PASSWORD=1234 -e MYSQL_USER=monitoringuser -e MYSQL_PASSWORD=sonata -e MYSQL_DATABASE=monitoring -p 3306:3306 sonatanfv/son-monitor-mysql
# influx
docker run -d --name son-monitor-influxdb -p 8086:8086 sonatanfv/son-monitor-influxdb

### broker 
# rabbitmq
docker run -d -p 5672:5672 -p 8080:15672 --name son-broker  -e RABBITMQ_CONSOLE_LOG=new rabbitmq:3-management
while ! nc -z $HOST_IP 5672; do
  sleep 1 && echo -n .; # waiting for rabbitmq
done;

### gui
docker run -d -p 80:80 --name son-gui -e "MON_URL=$HOST_IP:8000" -e "GK_URL=$HOST_IP:32001" -e "LOGS_URL=$HOST_IP:12900" sonatanfv/son-gui

### bss
docker run -d --name son-bss -p 25001:1337 sonatanfv/son-yo-gen-bss grunt serve:integration --gkApiUrl=http://$HOST_IP:32001 --debug

### gatekeeper
# gtkpkg
docker run --name son-gtkpkg -d -p 5100:5100 --add-host sp.int.sonata-nfv.eu:$HOST_IP -e CATALOGUES_URL=http://$HOST_IP:4002/catalogues -e RACK_ENV=integration sonatanfv/son-gtkpkg

# gtksrv
# (populate db)
docker run -i --add-host sp.int.sonata-nfv.eu:$HOST_IP -e DATABASE_HOST=$HOST_IP -e MQSERVER=amqp://guest:guest@$HOST_IP:5672 -e RACK_ENV=integration -e CATALOGUES_URL=http://$HOST_IP:4002/catalogues -e DATABASE_HOST=$HOST_IP -e DATABASE_PORT=5432 -e POSTGRES_PASSWORD=sonata -e POSTGRES_USER=sonatatest --rm=true sonatanfv/son-gtksrv bundle exec rake db:migrate
# (start gtksrv)
docker run --name son-gtksrv -d -p 5300:5300 --add-host sp.int.sonata-nfv.eu:$HOST_IP -e MQSERVER=amqp://guest:guest@$HOST_IP:5672 --add-host sp.int.sonata-nfv.eu:$HOST_IP -e CATALOGUES_URL=http://$HOST_IP:4002/catalogues --add-host jenkins.sonata-nfv.eu:$HOST_IP --link son-broker --link son-postgres -e RACK_ENV=integration -e DATABASE_HOST=$HOST_IP -e DATABASE_PORT=5432 -e POSTGRES_PASSWORD=sonata -e POSTGRES_USER=sonatatest -e MQSERVER=amqp://guest:guest@$HOST_IP:5672 -e RACK_ENV=integration sonatanfv/son-gtksrv

# gtkfnct
docker run --name son-gtkfnct -d -p 5500:5500 --add-host sp.int.sonata-nfv.eu:$HOST_IP -e RACK_ENV=integration -e CATALOGUES_URL=http://$HOST_IP:4002/catalogues sonatanfv/son-gtkfnct

# gtkrec
docker run --name son-gtkrec -d -p 5800:5800 --add-host sp.int.sonata-nfv.eu:$HOST_IP -e RACK_ENV=integration -e REPOSITORIES_URL=http://$HOST_IP:4002/records sonatanfv/son-gtkrec

# gtkvim
# (populate db)
docker run -i -e DATABASE_HOST=$HOST_IP -e MQSERVER=amqp://guest:guest@$HOST_IP:5672 -e RACK_ENV=integration -e DATABASE_PORT=5432 -e POSTGRES_PASSWORD=sonata -e POSTGRES_USER=sonatatest --rm=true sonatanfv/son-gtkvim bundle exec rake db:migrate
# (start gtkvim)
docker run --name son-gtkvim -d -p 5700:5700 -e MQSERVER=amqp://guest:guest@$HOST_IP:5672 --add-host sp.int.sonata-nfv.eu:$HOST_IP --add-host jenkins.sonata-nfv.eu:$HOST_IP --link son-broker --link son-postgres -e RACK_ENV=integration -e DATABASE_HOST=$HOST_IP -e DATABASE_PORT=5432 -e POSTGRES_PASSWORD=sonata -e POSTGRES_USER=sonatatest -e MQSERVER=amqp://guest:guest@$HOST_IP:5672 -e RACK_ENV=integration sonatanfv/son-gtkvim

# gtkapi
docker run --name son-gtkapi -d -p 32001:5000 --add-host sp.int.sonata-nfv.eu:$HOST_IP --link son-gtkfnct --link son-gtkrec --link son-gtkpkg --link son-gtksrv --link son-gtkvim -e RACK_ENV=integration -e PACKAGE_MANAGEMENT_URL=http://$HOST_IP:5100 -e SERVICE_MANAGEMENT_URL=http://$HOST_IP:5300 -e FUNCTION_MANAGEMENT_URL=http://$HOST_IP:5500 -e VIM_MANAGEMENT_URL=http://$HOST_IP:5700 -e RECORD_MANAGEMENT_URL=http://$HOST_IP:5800 sonatanfv/son-gtkapi 

### catalogues
docker run --name son-catalogue-repos -d -p 4002:4011 --add-host mongo:$HOST_IP sonatanfv/son-catalogue-repos
#sleep 15
#docker run --name son-catalogue-repos1 -i --rm=true --add-host mongo:$HOST_IP sonatanfv/son-catalogue-repos rake init:load_samples[integration]

### son-mano-framework
docker run -d --name pluginmanager -p 8001:8001 -e mongo_host=$HOST_IP -e broker_host=amqp://guest:guest@$HOST_IP:5672/%2F sonatanfv/pluginmanager /bin/bash /delayedstart.sh 10 son-mano-pluginmanager
sleep 15
docker run -d --name specificmanagerregistry --link son-broker:broker -e broker_name=son-broker,broker -e broker_host=amqp://guest:guest@$HOST_IP:5672/%2F -v '/var/run/docker.sock:/var/run/docker.sock' sonatanfv/specificmanagerregistry
docker run -d --name servicelifecyclemanagement -e url_nsr_repository=http://$HOST_IP:4002/records/nsr/ -e url_vnfr_repository=http://$HOST_IP:4002/records/vnfr/ -e url_monitoring_server=http://$HOST_IP:8000/api/v1/ -e broker_host=amqp://guest:guest@$HOST_IP:5672/%2F sonatanfv/servicelifecyclemanagement /bin/bash /delayedstart.sh 10 son-mano-service-lifecycle-management


### son-sp-infrabstract
docker run -d --name son-sp-infrabstract -e broker_host=$HOST_IP -e broker_uri=amqp://guest:guest@$HOST_IP:5672/%2F -e repo_host=$HOST_IP -e repo_port=5432 -e repo_user=sonatatest -e repo_pass=sonata sonatanfv/son-sp-infrabstract /docker-entrypoint.sh

# wait
while ! docker exec -t son-postgres psql -h localhost -U postgres -d vimregistry -c "SELECT * FROM VIM"; do
  sleep 2 && echo -n .; # waiting for table creation
done;

while ! docker exec -t son-postgres psql -h localhost -U postgres -d vimregistry -c "SELECT * FROM LINK_VIM"; do
  sleep 2 && echo -n .; # waiting for table creation
done;

# ADD THE VIMs
## PoP#1
docker exec -t son-postgres psql -h localhost -U postgres -d vimregistry -c "INSERT INTO VIM (uuid, type, vendor, endpoint, username, tenant, tenant_ext_net, tenant_ext_router, pass, authkey) VALUES ('1111-22222222-33333333-4444', 'compute', 'Heat', '$VIM_1_ENDPOINT', '$VIM_1_USER', '$VIM_1_TENANT', '$VIM_1_TENANT_EXT_NET', '$VIM_1_TENANT_EXT_ROUTER', '$VIM_1_PASSWORD', null);"
#docker exec -t son-postgres psql -h localhost -U postgres -d vimregistry -c "INSERT INTO VIM (uuid, type, vendor, endpoint, username, tenant, tenant_ext_net, tenant_ext_router, pass, authkey) VALUES ('aaaa-bbbbbbbb-cccccccc-dddd', 'networking', 'ovs', '10.100.32.200', 'operator', 'operator_ten', null, null, '0p3r470r', null);"
#docker exec -t son-postgres psql -h localhost -U postgres -d vimregistry -c "INSERT INTO LINK_VIM (COMPUTE_UUID, NETWORKING_UUID) VALUES ('1111-22222222-33333333-4444', 'aaaa-bbbbbbbb-cccccccc-dddd');"

## PoP#2
##docker exec -t son-postgres psql -h localhost -U postgres -d vimregistry -c "INSERT INTO VIM (uuid, type, vendor, endpoint, username, tenant, tenant_ext_net, tenant_ext_router, pass, authkey) VALUES ('5555-66666666-77777777-8888', 'compute', 'Heat', '10.100.32.10', 'admin', 'admin', '4ac2b52e-8f6b-4af3-ad28-38ede9d71c83', 'cbc5a4fa-59ed-4ec1-ad2d-adb270e21693', 'ii70mseq', null);"
##docker exec -t son-postgres psql -h localhost -U postgres -d vimregistry -c "INSERT INTO VIM (uuid, type, vendor, endpoint, username, tenant, tenant_ext_net, tenant_ext_router, pass, authkey) VALUES ('1324-acbdf1324-acbdf1324-3546', 'networking', 'odl', '10.100.32.10', null, null, null, null, null, null);"
##docker exec -t son-postgres psql -h localhost -U postgres -d vimregistry -c "INSERT INTO LINK_VIM (COMPUTE_UUID, NETWORKING_UUID) VALUES ('5555-66666666-77777777-8888', '1324-acbdf1324-acbdf1324-3546');"

# wait
while ! docker exec -t son-postgres psql -h localhost -U postgres -d vimregistry -c "SELECT * FROM VIM"; do
  sleep 2 && echo -n .; # waiting for table creation
done;



# fix firewall
#sudo ./firewall.sh
