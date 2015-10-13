#!/usr/bin/env bash

export DOCKER_IMAGE=atlassian/stash
export DOCKER_CONTAINER=stash
export DOCKER_CONTAINER_DATA_DIR=/var/atlassian/application-data/stash
export DOCKER_CONTAINER_PUBLISH="--publish=7990:7990 --publish=7999:7999"

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
