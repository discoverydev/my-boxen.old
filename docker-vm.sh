#!/bin/bash
source docker-vm_machine_lib.sh
#source docker-vm_boot2docker_lib.sh
echo "Docker Virtual Machine ($DOCKER_VM_NAME)"

create() {
    delete

    echo "* create $DOCKER_VM_NAME instance"
    dm_create

    echo "* setup $DOCKER_VM_NAME ($DOCKER_VM_IP)"
    dm_install_bootlocal

    echo "* enable host nfs daemon for /Users"
    sudo ./nfsd_util.sh $DOCKER_VM_IP `whoami` /Users

    echo "$DOCKER_VM_NAME running at $DOCKER_VM_IP"
    stop
}

delete() {
    echo "* shut $DOCKER_VM_NAME down and delete instance"
    dm_delete
}

start() {
    sudo ./nfsd_util.sh

    echo "* starting"
    dm_start

    echo "* show bootlocal log"
    sleep 3
    dm_show_bootlocal_log

    echo "$DOCKER_VM_NAME running at $DOCKER_VM_IP"
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

$1
