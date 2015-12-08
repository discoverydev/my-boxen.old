#!/usr/bin/env bash

export DOCKER_IMAGE=atlassian/stash
export DOCKER_CONTAINER=stash
export DOCKER_CONTAINER_DATA_DIR=/var/atlassian/application-data/stash
export DOCKER_CONTAINER_PUBLISH="--publish=7990:7990 --publish=7999:7999"
export DOCKER_VM_MEMORY=3072
export DOCKER_VM_CPUS=3
export DOCKER_HOST=tcp://192.168.99.100:2376
export DOCKER_MACHINE_NAME=stash-vm
export DOCKER_TLS_VERIFY=1
export DOCKER_CERT_PATH=/Users/ga-mlsdiscovery/.docker/machine/machines/$DOCKER_MACHINE_NAME

source docker-vm_lib.sh

_setupvm() {
	nat ${DOCKER_CONTAINER}-http 7990 7990
	nat ${DOCKER_CONTAINER}-ssh 7999 7999
}

tail-log() {
	tail -n 100 -f $DOCKER_HOST_DATA_DIR/log/atlassian-stash.log
}

open() {
	/usr/bin/open "http://localhost:7990/"
}

for arg in "$@"; do $arg; done
