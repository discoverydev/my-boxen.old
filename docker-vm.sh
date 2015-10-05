#!/bin/bash
source docker-vm_machine_lib.sh
#source docker-vm_boot2docker_lib.sh
echo "Docker Virtual Machine ($DOCKER_VM_NAME)"
echo DOCKER_VM_VBOXNET=${DOCKER_VM_VBOXNET}
echo DOCKER_VM_MEMORY=${DOCKER_VM_MEMORY}
echo DOCKER_VM_CPUS=${DOCKER_VM_CPUS}
echo DOCKER_VM_HOST=${DOCKER_VM_HOST}
echo DOCKER_VM_ARGS=${DOCKER_VM_ARGS}

create() {
    delete

    echo "* create $DOCKER_VM_NAME instance"
    dm_create

    echo "* setup $DOCKER_VM_NAME ($DOCKER_VM_IP, host=$DOCKER_VM_HOST)"
    dm_install_bootlocal

    echo "* enable host nfs daemon for /Users"
    sudo ./nfsd_util.sh $DOCKER_VM_IP `whoami` /Users

    echo "$DOCKER_VM_NAME running at $DOCKER_VM_IP"
    stop

    #echo "* setting host only adapter to $DOCKER_VM_VBOXNET"
    #VBoxManage modifyvm "$DOCKER_VM_NAME"  --hostonlyadapter1 $DOCKER_VM_VBOXNET   
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

env() {
    dm_env
}

ssh() {
    dm_ssh
}

$1
