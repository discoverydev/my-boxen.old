#!/usr/bin/env bash

export DOCKER_IMAGE=orchardup/postgresql
export DOCKER_CONTAINER=sonardb
export DOCKER_CONTAINER_DATA_DIR=/opt/db/sonarqube/
export DOCKER_CONTAINER_PUBLISH="--publish=5432:5432"
export DOCKER_VM_CPUS=1

source docker-vm_lib.sh

_setupvm() {
	nat ${DOCKER_CONTAINER}-db 5432 5432
}

open() {
	/usr/bin/open "http://localhost:5432/"
}

for arg in "$@"; do $arg; done
