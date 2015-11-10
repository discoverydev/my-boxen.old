#!/bin/bash

source docker-vm_shared_lib.sh
source docker-vm_machine_lib.sh

printf '# '; printf '*%.0s' $(seq 1 ${#DOCKER_VM_NAME}); echo "***************************"
echo "# * $DOCKER_VM_NAME Docker Virtual Machine *"
printf '# '; printf '*%.0s' $(seq 1 ${#DOCKER_VM_NAME}); echo "***************************"


init() {
    create
    reinit
}

reinit() {
    modifyvm
    start
    bootlocal-init
    docker-init
}

create() {
    delete
    echo "*** create $DOCKER_VM_NAME instance"
    dm_create
    nfsd-init
    launchd_install
}

delete() {
    echo "*** shut $DOCKER_VM_NAME down and delete instance"
    dm_delete
    launchd_uninstall
}

start() {
    echo "*** starting"
    dm_start
    echo "$DOCKER_VM_NAME running at $DOCKER_VM_IP"
}

stop() {
    echo "*** stopping"
    dm_stop
}

restart() {
    stop
    start
}

attach() {
    dm_is_running
    if [[ $? == 0 ]]; then 
        echo "*** attaching to $DOCKER_CONTAINER"
        dm_env
        docker attach --sig-proxy=false $DOCKER_CONTAINER
    else
        echo "*** $DOCKER_VM_NAME is not running"
    fi
}

ssh() {
    dm_ssh
}

env() {
    dm env
    echo '# eval "$('$0' env)"' 
}


##
## nfsd commands
##

nfsd-init() {
    echo "*** enable host nfs daemon for /Users ($DOCKER_VM_IP)"
    sudo ./nfsd_util.sh $DOCKER_VM_IP `whoami` /Users
    echo "*** enable host nfs daemon for /opt/boxen ($DOCKER_VM_IP)"
    sudo ./nfsd_util.sh $DOCKER_VM_IP `whoami` /opt/boxen
}


##
## virtualbox commands
##

modifyvm() {
    stop
    echo "*** setting $DOCKER_VM_NAME memory to $DOCKER_VM_MEMORY"
    VBoxManage modifyvm $DOCKER_VM_NAME --memory $DOCKER_VM_MEMORY
    echo "*** setting $DOCKER_VM_NAME cpus to $DOCKER_VM_CPUS"
    VBoxManage modifyvm $DOCKER_VM_NAME --cpus $DOCKER_VM_CPUS

    _setupvm  # must be defined in calling script  
}

nat() {
    local name=$1
    local hostport=$2
    local guestport=$3
    echo "*** exposing $guestport to the host as $hostport ($name)"
    VBoxManage modifyvm "$DOCKER_VM_NAME" --natpf1 delete $name &>/dev/null
    VBoxManage modifyvm "$DOCKER_VM_NAME" --natpf1 "$name,tcp,,$hostport,,$guestport"
}


##
## docker commands
##

docker-init() {
    docker-delete
    if [[ "$DOCKER_CONTAINER" != "" ]]; then
        local volumes="" 
        # look to see if the data directory is being used
        if [[ "$DOCKER_CONTAINER_DATA_DIR" != "" ]]; then
            mkdir -p $DOCKER_HOST_DATA_DIR
            volumes="--volume=$DOCKER_HOST_DATA_DIR:$DOCKER_CONTAINER_DATA_DIR --volume=/opt/boxen:/opt/boxen"
        fi
        local publish=$DOCKER_CONTAINER_PUBLISH
        local hosts=$DOCKER_CONTAINER_HOSTS
        local environment=$DOCKER_CONTAINER_ENV

        echo "*** initializing $DOCKER_CONTAINER container with image $DOCKER_IMAGE"
        docker run --name $DOCKER_CONTAINER --restart=always --detach=true $environment $hosts $volumes $publish $DOCKER_IMAGE
    fi
    status
}

docker-delete() {
    if [[ "$DOCKER_CONTAINER" != "" ]]; then
        # look for existing container to delete
        docker ps -a | grep $DOCKER_CONTAINER\$ > /dev/null
        if [[ $? == 0 ]]; then
            echo "*** removing $DOCKER_CONTAINER container"
            docker stop $DOCKER_CONTAINER > /dev/null
            docker rm -f $DOCKER_CONTAINER > /dev/null
        fi
    fi
}


##
## bootlocal commands
##

bootlocal-init() {
    echo "*** init bootlocal script"
    bootlocal-install
    bootlocal-run
}

bootlocal-install() {
    echo "*** install bootlocal script"
    dm_install_bootlocal
}

bootlocal-run() {
    echo "*** run bootlocal script"
    dm_env
    dm_run_bootlocal
}

bootlocal-cat() {
    echo "*** BEGIN bootlocal"
    dm_cat_bootlocal
    echo "*** END bootlocal"    
}

bootlocal-log() {
    echo "*** BEGIN bootlocal log"
    dm_cat_bootlocal_log
    echo "*** END bootlocal log"
}


##
## info commands
##

settings() {
    echo "*** settings"
    echo DOCKER_IMAGE=${DOCKER_IMAGE} 
    echo DOCKER_CONTAINER=${DOCKER_CONTAINER} 
    echo DOCKER_CONTAINER_ENV=${DOCKER_CONTAINER_ENV}
    echo DOCKER_CONTAINER_PUBLISH=${DOCKER_CONTAINER_PUBLISH}
    echo DOCKER_CONTAINER_HOSTS=${DOCKER_CONTAINER_HOSTS}
    echo DOCKER_CONTAINER_DATA_DIR=${DOCKER_CONTAINER_DATA_DIR}
    echo DOCKER_HOST_DATA_DIR=${DOCKER_HOST_DATA_DIR}
    echo DOCKER_VM_NAME=${DOCKER_VM_NAME}
    echo DOCKER_VM_MEMORY=${DOCKER_VM_MEMORY}
    echo DOCKER_VM_CPUS=${DOCKER_VM_CPUS}
    echo DOCKER_VM_USER=${DOCKER_VM_USER}
    dm_exists
    if [[ $? == 0 ]]; then
        echo host_adapter=$(host_adapter)
        echo host_ip=$(host_ip)
    fi
}

status() {
    dm_exists
    if [[ $? == 0 ]]; then
        echo "*** docker-machine status"
        dm status

        dm_is_running
        if [[ $? == 0 ]]; then 
            dm_env
            echo "*** docker processes"
            docker ps
        fi
    else
        echo "*** docker-machine $DOCKER_VM_NAME does not exist"
    fi
}

inspect() {
    dm_exists
    if [[ $? == 0 ]]; then
        echo "*** $DOCKER_VM_NAME instance info"
        VBoxManage showvminfo $DOCKER_VM_NAME

        dm_is_running
        if [[ $? == 0 ]]; then 
            dm_env
            echo "*** $DOCKER_IMAGE image info"
            docker inspect $DOCKER_IMAGE
        fi
    else
        echo "*** docker-machine $DOCKER_VM_NAME does not exist"
    fi
}
