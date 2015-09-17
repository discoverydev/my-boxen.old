#!/bin/sh

progress_bar() {
  SECS=5
  while [[ 0 -ne $SECS ]]; do
    echo ".\c"
    sleep 1
    SECS=$[$SECS-1]
  done
  echo "\nTime is up, moving on."
}

echo "* Initializing Build machine"
echo "** shutting boot2docker down"
boot2docker down
echo "** deleting existing boot2docker images"
boot2docker delete

echo "** initialize boot2docker"
boot2docker init

echo "** increasing boot2docker memory"
VBoxManage modifyvm boot2docker-vm --memory 2048
echo "** exposing mockserver port to the outside world"
VBoxManage modifyvm boot2docker-vm --natpf1 'mockserver-http-9001,tcp,,9001,,9001'

echo "** boot2docker startup"
boot2docker up
$(boot2docker shellinit)
boot2docker ip

echo "* defining directory for data shares"
DATA_DIR=/Users/Shared/data
mkdir -p $DATA_DIR

echo "** docker mockserver startup"
if [ "$#" -eq 1 ] && [ -f $1 ]
then
  echo "* base mockserver image provided -> untar'ing $1 to $DATA_DIR/mockserver"
  rm -rf $DATA_DIR/mockserver
  mkdir -p $DATA_DIR/mockserver
  cd $DATA_DIR/mockserver
  tar xvf $1 
else
  echo "* base mockserver image NOT provided -> assuming default"
  mkdir -p $DATA_DIR/mockserver
fi

mockserver_path="${DATA_DIR}/mockserver/api-blueprint-mockserver"
specs_path="${DATA_DIR}/mockserver/api-blueprint-specs"

echo "* convert api specs to json"
drafter --format=json ${specs_path}/hello_world.apib > ${mockserver_path}/hello_world.json
drafter --format=json ${specs_path}/android_global_config.apib > ${mockserver_path}/android_global_config.json

mockserver_path="/usr/local/src/api-blueprint-mockserver"
specs_path="/usr/local/src/api-blueprint-specs"

docker run --name=mockserver -dt -v $DATA_DIR/mockserver:/usr/local/src -p 9001:9001 java /bin/bash -c "${mockserver_path}/mockserver -b ${mockserver_path}/android_global_config.json -h 0.0.0.0 -p 9001"
docker ps

echo "** setting docker timezone to EST"
ENV TZ=America/New_York

echo "* wait for mockserver to startup"
progress_bar

echo "** open mockserver browser"
open http://localhost:9001/message
