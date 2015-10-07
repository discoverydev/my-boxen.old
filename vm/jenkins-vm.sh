#!/usr/bin/env bash

export DOCKER_IMAGE=jenkins
export DOCKER_CONTAINER=jenkins
export DOCKER_VM_NAME=jenkins-vm
export DOCKER_VM_MEMORY=2048
export DOCKER_VM_CPUS=2

source docker-vm.sh

init_post_create() {
	nat ${DOCKER_CONTAINER}-http 8080 8080
	nat ${DOCKER_CONTAINER}-jnlp 50000 50000
}

init_docker_run() {
	local hosts="--add-host stash:192.168.8.31 --add-host nexus:192.168.8.31 --add-host confluence:192.168.8.34"
	local volumes="--volume=$DOCKER_DATA_DIR:/var/jenkins_home --volume=/opt/boxen:/opt/boxen"
	local publish="--publish=8080:8080 --publish=50000:50000"
	docker run --name $DOCKER_CONTAINER --restart=always --detach=true $hosts $volumes $publish $DOCKER_IMAGE
}

clone() {
	echo "* clone $DOCKER_CONTAINER config"
	rm -rf $DOCKER_DATA_DIR
	mkdir -p $DOCKER_DATA_DIR
	git clone http://ga-mlsdiscovery@192.168.8.31:7990/scm/util/jenkins_base_config.git $DOCKER_DATA_DIR
}

$1