#!/usr/bin/env bash

export DOCKER_VM_NAME=nexus-vm
export DOCKER_VM_MEMORY=2048
export DOCKER_VM_CPUS=2
export DOCKER_CONTAINER=nexus

source docker-vm.sh

init() {
	stop
	create
	nat ${DOCKER_CONTAINER}-http 8081 8081
	start

	DATA_DIR=/Users/Shared/data/$DOCKER_CONTAINER

	echo "** docker $DOCKER_CONTAINER startup"
	mkdir -p $DATA_DIR
	docker run --name $DOCKER_CONTAINER --restart=always --add-host stash:192.168.8.31 --add-host jenkins:192.168.8.31 --add-host confluence:192.168.8.34 -d -v $DATA_DIR:/sonatype-work -p 8081:8081 sonatype/nexus
	docker ps

	echo "** open $DOCKER_CONTAINER browser"
	open http://localhost:8081/
}

$1