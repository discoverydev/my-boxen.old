#!/usr/bin/env bash

export DOCKER_IMAGE=discoverydev/sonarqube-docker
export DOCKER_CONTAINER=sonarqube
export DOCKER_CONTAINER_DATA_DIR=/opt/db/sonarqube/
export DOCKER_CONTAINER_PUBLISH="--publish=9000:9000 --publish=443:443" 
export DOCKER_VM_CPUS=1

source docker-vm_lib.sh

_setupvm() {
	nat ${DOCKER_CONTAINER}-http 9000 9000
	nat ${DOCKER_CONTAINER}-http 443 443 
}

open() {
	/usr/bin/open "http://localhost:9000/"
}

for arg in "$@"; do $arg; done
