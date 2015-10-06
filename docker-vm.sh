#!/bin/bash
source docker-vm_machine_lib.sh
echo "Docker Virtual Machine ($DOCKER_VM_NAME)"

init() {
    stop
    create
    init_post_create
    start

    echo "* docker $DOCKER_CONTAINER initialization"
    mkdir -p $DOCKER_DATA_DIR
    init_docker_run
    docker ps
}

create() {
    delete

    echo "* create $DOCKER_VM_NAME instance"
    dm_create

    echo "* setup $DOCKER_VM_NAME ($DOCKER_VM_IP)"
    dm_install_bootlocal

    echo "* enable host nfs daemon for /Users"
    sudo ./nfsd_util.sh $DOCKER_VM_IP `whoami` /Users
    echo "* enable host nfs daemon for /opt/boxen"
    sudo ./nfsd_util.sh $DOCKER_VM_IP `whoami` /opt/boxen

    echo "* setting vm options"
    stop
    VBoxManage modifyvm $DOCKER_VM_NAME --memory $DOCKER_VM_MEMORY
    VBoxManage modifyvm $DOCKER_VM_NAME --cpus $DOCKER_VM_CPUS
}

nat() {
    local name=$1
    local hostport=$2
    local guestport=$3
    echo "* exposing $guestport to the host as $hostport ($name)"
    VBoxManage modifyvm "$DOCKER_VM_NAME" --natpf1 "$name,tcp,,$hostport,,$guestport"
}

delete() {
    echo "* shut $DOCKER_VM_NAME down and delete instance"
    dm_delete
}

start() {
    echo "* starting"
    dm_start

    echo "* begin bootlocal log"
    sleep 3
    dm_show_bootlocal_log
    echo "* end bootlocal log"

    echo "* docker ps"
    docker ps

    echo "$DOCKER_VM_NAME running at $DOCKER_VM_IP.  Use 'attach' to see the console output."
}

stop() {
    echo "* stopping"
    dm_stop
}

restart() {
    stop
    start
}

bootlocal() {
    dm_run_bootlocal
}

bootlocal-log() {
    dm_show_bootlocal_log
}

ssh() {
    dm_ssh
}

attach() {
    dm_env
    docker attach --sig-proxy=false $DOCKER_CONTAINER
}

status() {
    dm status
    dm_env
    docker ps
}

inspect() {
    dm_env
    docker inspect $DOCKER_IMAGE
}

settings() {
    echo DOCKER_IMAGE=${DOCKER_IMAGE} 
    echo DOCKER_CONTAINER=${DOCKER_CONTAINER} 
    echo DOCKER_DATA_DIR=${DOCKER_DATA_DIR}
    echo DOCKER_VM_NAME=${DOCKER_VM_NAME}
    echo DOCKER_VM_MEMORY=${DOCKER_VM_MEMORY}
    echo DOCKER_VM_CPUS=${DOCKER_VM_CPUS}
    echo DOCKER_VM_ARGS=${DOCKER_VM_ARGS}
}