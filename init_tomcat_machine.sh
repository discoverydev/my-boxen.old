#!/bin/sh

echo "* Initializing Build machine"
echo "** shutting boot2docker down"
boot2docker down
echo "** deleting existing boot2docker images"
boot2docker delete

echo "** initialize boot2docker"
boot2docker init

echo "** increasing boot2docker memory"
VBoxManage modifyvm boot2docker-vm --memory 2048
echo "** exposing tomcat port to the outside world"
VBoxManage modifyvm boot2docker-vm --natpf1 'tomcat-http-8888,tcp,,8888,,8888'

echo "** boot2docker startup"
boot2docker up
$(boot2docker shellinit)
boot2docker ip

echo "* defining directory for data shares (must be under the above nfs share)"
DATA_DIR=/Users/Shared/data
mkdir -p $DATA_DIR

echo "** docker tomcat startup"
if [ "$#" -eq 1 ] && [ -f $1 ]
then
  echo "* base tomcat image provided -> untar'ing $1 to $DATA_DIR/tomcat"
  rm -rf $DATA_DIR/tomcat
  mkdir -p $DATA_DIR/tomcat
  cd $DATA_DIR/tomcat
  tar xvf $1 
else
  echo "* base tomcat image NOT provided -> assuming default"
  mkdir -p $DATA_DIR/tomcat
fi
docker run -d -p 8888:8080 --name tomcat -v $DATA_DIR/tomcat:/usr/local/tomcat tomcat:8.0
docker ps

echo "** setting docker timezone to EST"
ENV TZ=America/New_York

echo "** open tomcat browser"
open http://localhost:8888/
