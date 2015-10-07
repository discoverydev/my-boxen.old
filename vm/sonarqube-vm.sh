#!/usr/bin/env bash

export DOCKER_IMAGE=discoverydev/sonarqube-docker
export DOCKER_CONTAINER=sonarqube
export DOCKER_VM_NAME=sonarqube-vm
export DOCKER_VM_MEMORY=2048
export DOCKER_VM_CPUS=1

source docker-vm.sh

init_post_create() {
	nat ${DOCKER_CONTAINER}-http 9000 9000
	nat ${DOCKER_CONTAINER}-http 9092 9092
}

init_docker_run() {
	local hosts="--add-host stash:192.168.8.31 --add-host nexus:192.168.8.31 --add-host confluence:192.168.8.34"
	local volumes="--volume=$DOCKER_DATA_DIR:/var/local/atlassian/confluence"
	local publish="--publish=9000:9000 --publish=9092:9092"
	docker run --name $DOCKER_CONTAINER --restart=always --detach=true $hosts $volumes $publish $DOCKER_IMAGE
}

$1
