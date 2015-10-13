#!/usr/bin/env bash

export DOCKER_IMAGE=jenkins
export DOCKER_CONTAINER=jenkins
export DOCKER_CONTAINER_DATA_DIR=/var/jenkins_home
export DOCKER_CONTAINER_PUBLISH="--publish=8080:8080 --publish=50000:50000"
export DOCKER_CONTAINER_ENV="--env JAVA_OPTS=-Xmx2g"
export DOCKER_VM_MEMORY=3072

source docker-vm_lib.sh

_setupvm() {
	nat ${DOCKER_CONTAINER}-http 8080 8080
	nat ${DOCKER_CONTAINER}-jnlp 50000 50000
}

open() {
	/usr/bin/open "http://localhost:8080/"
}

clone() {
	echo "*** clone $DOCKER_CONTAINER config into $DOCKER_HOST_DATA_DIR"
	rm -rf $DOCKER_HOST_DATA_DIR
	mkdir -p $DOCKER_HOST_DATA_DIR
	git clone http://ga-mlsdiscovery@192.168.8.31:7990/scm/util/jenkins_base_config.git $DOCKER_HOST_DATA_DIR
}

for arg in "$@"; do $arg; done
