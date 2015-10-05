#!/usr/bin/env bash

export DOCKER_VM_VBOXNET=vboxnet2
export DOCKER_VM_NAME=nexus-vm
export DOCKER_VM_MEMORY=2048
export DOCKER_VM_CPUS=2

source docker-vm.sh

stop
create
nat nexus-http 8081 8081
start

echo "* defining directory for data shares (must be under the above nfs share)"
DATA_DIR=/Users/Shared/data
mkdir -p $DATA_DIR

echo "** docker nexus startup"
mkdir -p $DATA_DIR/nexus
docker run --name nexus --add-host stash:192.168.8.31 --add-host jenkins:192.168.8.31 --add-host confluence:192.168.8.34 -d -v $DATA_DIR/nexus:/sonatype-work -p 8081:8081 sonatype/nexus
docker ps

echo "** open nexus browser"
open http://localhost:8081/


