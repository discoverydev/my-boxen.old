#!/usr/bin/env bash

export DOCKER_IMAGE=sonatype/nexus
export DOCKER_CONTAINER=nexus
export DOCKER_VM_NAME=nexus-vm
export DOCKER_VM_MEMORY=2048
export DOCKER_VM_CPUS=2

source docker-vm.sh

init_post_create() {
	nat ${DOCKER_CONTAINER}-http 8081 8081
}

init_docker_run() {
	local hosts="--add-host=stash:192.168.8.31 --add-host=nexus:192.168.8.31 --add-host=confluence:192.168.8.34"
	local volumes="--volume=$DOCKER_DATA_DIR:/sonatype-work"
	local publish="--publish=8081:8081"
	docker run --name $DOCKER_CONTAINER --restart=always --detach=true $hosts $volumes $publish $DOCKER_IMAGE
}

$1