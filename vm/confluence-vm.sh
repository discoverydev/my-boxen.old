#!/usr/bin/env bash

export DOCKER_IMAGE=cptactionhank/atlassian-confluence:5.7.5
export DOCKER_CONTAINER=confluence
export DOCKER_CONTAINER_DATA_DIR=/var/local/atlassian/confluence
export DOCKER_CONTAINER_PUBLISH="--publish=8090:8090"

source docker-vm_lib.sh

_setupvm() {
	nat ${DOCKER_CONTAINER}-http 8090 8090
}

tail-log() {
	tail -n 100 -f $DOCKER_HOST_DATA_DIR/logs/atlassian-confluence.log
}

open() {
	/usr/bin/open "http://localhost:8090/"
}

for arg in "$@"; do $arg; done
