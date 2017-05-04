#!/bin/bash

# service platform configuration
HOST_IP="172.0.0.199"

echo "Stopping all old containers ..."

# clean
docker rm -f son-postgres
docker rm -f son-broker
docker rm -f son-mongo
docker rm -f son-pluginmanager
docker rm -f son-sp-infrabstract

echo "...done"

### databases
# postgres
docker run -d -p 5432:5432 --name son-postgres -e POSTGRES_DB=gatekeeper -e POSTGRES_USER=sonatatest -e POSTGRES_PASSWORD=sonata ntboes/postgres-uuid
while ! nc -z $HOST_IP 5432; do
  sleep 1 && echo -n .; # waiting for postgres
done;

# mongo
#docker run -d -p 27017:27017 --name son-mongo mongo
#while ! nc -z $HOST_IP 27017; do
#  sleep 1 && echo -n .; # waiting for mongo
#done;

### broker 
# rabbitmq
#docker run -d -p 5672:5672 -p 8080:15672 --name son-broker  -e RABBITMQ_CONSOLE_LOG=new rabbitmq:3-management
#while ! nc -z $HOST_IP 5672; do
#  sleep 1 && echo -n .; # waiting for rabbitmq
#done;

echo ""
echo "Postgres, Mongo, RabbitMQ started."
