#!/usr/bin/env bash

export DOCKER_IMAGE=atlassian/stash
export DOCKER_CONTAINER=stash
export DOCKER_VM_NAME=stash-vm
export DOCKER_VM_MEMORY=2048
export DOCKER_VM_CPUS=2

source docker-vm.sh

init_post_create() {
	nat ${DOCKER_CONTAINER}-http 7990 7990
	nat ${DOCKER_CONTAINER}-ssh 7999 7999
}

init_docker_run() {
	local hosts="--add-host stash:192.168.8.31 --add-host nexus:192.168.8.31 --add-host confluence:192.168.8.34"
	local volumes="--volume=$DOCKER_DATA_DIR:/var/atlassian/application-data/stash"
	local publish="--publish=7990:7990 --publish=7999:7999"
	docker run --name $DOCKER_CONTAINER --restart=always --detach=true $hosts $volumes $publish $DOCKER_IMAGE
}

tail-log() {
	tail -n 100 -f $DOCKER_DATA_DIR/log/atlassian-stash.log
}

$1
