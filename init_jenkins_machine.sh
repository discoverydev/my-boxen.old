#!/usr/bin/env bash

export DOCKER_VM_VBOXNET=vboxnet2
export DOCKER_VM_NAME=jenkins-vm
export DOCKER_VM_MEMORY=2048
export DOCKER_VM_CPUS=2

source docker-vm.sh

stop
create
nat jenkins-http-8080 8080 8080
nat jenkins-http-50000 50000 50000
start

echo "* defining directory for data shares (must be under the above nfs share)"
DATA_DIR=/Users/Shared/data
mkdir -p $DATA_DIR

echo "** docker jenkins startup"
mkdir -p $DATA_DIR/jenkins
 
read -p "clone jenkins from stash (probably not)?: (N/y)" CLONE_JENKINS
CLONE_JENKINS=${CLONE_JENKINS:-n}
 
if [ "$CLONE_JENKINS" = y ]
then
  echo "* cloning jenkins"
  rm -rf $DATA_DIR/jenkins
  mkdir -p $DATA_DIR/jenkins
  echo "* clone jenkins config"
  git clone http://ga-mlsdiscovery@192.168.8.31:7990/scm/util/jenkins_base_config.git /Users/Shared/data/jenkins
else
  echo "* using existing jenkins data dir"
fi

echo "** docker jenkins startup"
docker run --add-host stash:192.168.8.31 --add-host nexus:192.168.8.31 --add-host confluence:192.168.8.34 --name jenkins -d -v $DATA_DIR/jenkins:/var/jenkins_home -v /opt/boxen:/opt/boxen -p 8080:8080 -p 50000:50000 jenkins
docker ps

echo "** open jenkins browser"
open http://localhost:8080/