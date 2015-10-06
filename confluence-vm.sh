#!/usr/bin/env bash

export DOCKER_IMAGE=cptactionhank/atlassian-confluence:5.7.5
export DOCKER_CONTAINER=confluence
export DOCKER_VM_NAME=confluence-vm
export DOCKER_VM_MEMORY=2048
export DOCKER_VM_CPUS=2

source docker-vm.sh

init_post_create() {
	nat ${DOCKER_CONTAINER}-http 8090 8090
}

init_docker_run() {
	local hosts="--add-host stash:192.168.8.31 --add-host nexus:192.168.8.31 --add-host confluence:192.168.8.34"
	local volumes="--volume=$DOCKER_DATA_DIR:/var/local/atlassian/confluence"
	local publish="--publish=8090:8090"
	docker run --name $DOCKER_CONTAINER --restart=always --detach=true $hosts $volumes $publish $DOCKER_IMAGE
}

tail-log() {
	tail -n 100 -f $DOCKER_DATA_DIR/logs/atlassian-confluence.log
}

$1
