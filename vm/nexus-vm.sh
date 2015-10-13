#!/usr/bin/env bash

export DOCKER_IMAGE=sonatype/nexus
export DOCKER_CONTAINER=nexus
export DOCKER_CONTAINER_DATA_DIR=/sonatype-work
export DOCKER_CONTAINER_PUBLISH="--publish=8081:8081"

source docker-vm_lib.sh

_setupvm() {
	nat ${DOCKER_CONTAINER}-http 8081 8081
}

tail-log() {
	tail -n 100 -f $DOCKER_HOST_DATA_DIR/logs/nexus.log
}

open() {
	/usr/bin/open "http://localhost:8081/"
}

for arg in "$@"; do $arg; done