#!/usr/bin/env bash

export DOCKER_VM_NAME=stash-vm
export DOCKER_VM_MEMORY=2048
export DOCKER_VM_CPUS=2
export DOCKER_CONTAINER=stash

source docker-vm.sh

init() {
	stop
	create
	nat ${DOCKER_CONTAINER}-http 7990 7990
	nat ${DOCKER_CONTAINER}-ssh 7999 7999
	start

	DATA_DIR=/Users/Shared/data/$DOCKER_CONTAINER

	echo "** docker $DOCKER_CONTAINER startup"
	mkdir -p $DATA_DIR
    docker run --name $DOCKER_CONTAINER --restart=always --add-host nexus:192.168.8.31 --add-host jenkins:192.168.8.31 --add-host confluence:192.168.8.34 -d -v $DATA_DIR:/var/atlassian/application-data/stash -p 7990:7990 -p 7999:7999 atlassian/stash
	docker ps

	echo "** open $DOCKER_CONTAINER browser"
	open http://localhost:7990/
}

$1
