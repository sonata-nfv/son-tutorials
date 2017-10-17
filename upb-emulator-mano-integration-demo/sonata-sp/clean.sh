#!/bin/bash
#
# stop SONATA SP components
#
echo "Cleaning the environment..."
echo "Stopping and deleting containers ..."
docker rm -fv $(docker ps -qa)

echo "Done."
