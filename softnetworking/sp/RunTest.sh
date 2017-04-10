#/bin/bash
set -e
set -x

# Checkout code and check for updates

if [ ! -d "son-tests" ]; then
  git clone https://github.com/sonata-nfv/son-tests/
fi

cd ./son-tests
git pull origin master

# -- build the trigger-container


docker build -t slm_ia_trigger ./int-slm-infrabstractV2/test-trigger
docker build -t slm_ia_cleaner ./int-slm-infrabstractV2/test-cleaner

echo "" > ./int-slm-infrabstractV2/triggerLog.txt
echo "" > ./int-slm-infrabstractV2/instanceId.conf

## Start the test trigger

docker run --rm --link son-broker -e broker_host=amqp://guest:guest@son-broker:5672/%2F --name int_slm_ia_trigger slm_ia_trigger /plugin/test_trigger/test.sh 2>&1 | tee -i ./int-slm-infrabstractV2/triggerLog.txt

cat ./int-slm-infrabstractV2/triggerLog.txt | grep "OUTPUT" | cut -d\: -f5 > /int-slm-infrabstractV2/instanceId.conf


