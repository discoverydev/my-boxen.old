#!/usr/bin/env bash

export DOCKER_VM_NAME=jenkins-vm
export DOCKER_VM_MEMORY=2048
export DOCKER_VM_CPUS=2
export DOCKER_CONTAINER=jenkins

source docker-vm.sh

init() {
	stop
	create
	nat ${DOCKER_CONTAINER}-http 8080 8080
	nat ${DOCKER_CONTAINER}-jnlp 50000 50000
	start

	DATA_DIR=/Users/Shared/data/$DOCKER_CONTAINER

	echo "** docker $DOCKER_CONTAINER startup"
	mkdir -p $DATA_DIR
	docker run --name $DOCKER_CONTAINER --restart=always --add-host stash:192.168.8.31 --add-host nexus:192.168.8.31 --add-host confluence:192.168.8.34 -d -v $DATA_DIR:/var/jenkins_home -v /opt/boxen:/opt/boxen -p 8080:8080 -p 50000:50000 jenkins
	docker ps

    echo "** open $DOCKER_CONTAINER browser"
    open http://localhost:8080/
}

clone() {
	DATA_DIR=/Users/Shared/data/$DOCKER_CONTAINER
 
	echo "* clone $DOCKER_CONTAINER config"
	rm -rf $DATA_DIR
	mkdir -p $DATA_DIR
	git clone http://ga-mlsdiscovery@192.168.8.31:7990/scm/util/jenkins_base_config.git $DATA_DIR
}

$1