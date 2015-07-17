: ${DOCKER_VM_VBOXNET=vboxnet0}
: ${DOCKER_VM_NAME=docker-vm}
: ${DOCKER_VM_MEMORY=2048}
: ${DOCKER_VM_CPUS=2}
: ${DOCKER_VM_HOST=`ifconfig $DOCKER_VM_VBOXNET | grep 'inet ' | cut -d ' ' -f 2`}
: ${DOCKER_VM_ARGS=}

dm() {
    local command=$1
    docker-machine $command $DOCKER_VM_NAME
}

dm_create() {
    docker-machine create -d virtualbox $DOCKER_VM_NAME --virtualbox-memory "$DOCKER_VM_MEMORY" --virtualbox-cpu-count "$DOCKER_VM_CPUS"
    eval $( dm env )
    export DOCKER_VM_IP=$( dm ip )
}

dm_start() {
    dm start
    eval $( dm env )
    export DOCKER_VM_IP=$( dm ip )
}

dm_stop() {
    dm stop
}

dm_delete() {
    dm_stop
    dm rm
}

dm_ssh() {
    docker-machine $DOCKER_VM_ARGS ssh $DOCKER_VM_NAME $1 $2 $3 $4 $5 $7 $8 $9
}

copy_to_dm_home() {
    local src=$1
    docker-machine scp $src $DOCKER_VM_NAME:
}

dm_run_bootlocal() {
    dm_ssh "/var/lib/boot2docker/bootlocal.sh"
}

dm_install_bootlocal() {
    local bootlocal_file=$1
    local bootlocal_tmp=/tmp/bootlocal.sh
    if [ -f "$bootlocal_file" ]; then
        cp $bootlocal_file $bootlocal_tmp
    else
        cat <<EOF >$bootlocal_tmp
echo "=== wait for host networking"
EXIT_RESULT=1
while [ \${EXIT_RESULT} -gt 0 ]; do
    sleep 1
    ping -c 1 $DOCKER_VM_HOST > /dev/null 2>&1
    EXIT_RESULT=\$?
done
sleep 3

echo "=== start nfs"
sudo /usr/local/etc/init.d/nfs-client start

echo "=== remount /Users using nfs"
sudo umount /Users
sudo mount $DOCKER_VM_HOST:/Users /Users -o rw,async,noatime,rsize=32768,wsize=32768,proto=tcp

echo "=== show /Users"
mount | grep /Users
ls /Users
EOF
    fi

    copy_to_dm_home $bootlocal_tmp
    dm_ssh "chmod +x bootlocal.sh"
    dm_ssh "sudo mv bootlocal.sh /var/lib/boot2docker/"
    dm_ssh "sudo chown root:root /var/lib/boot2docker/bootlocal.sh"
    rm $bootlocal_tmp
}

dm_show_bootlocal() {
    dm_ssh "cat /var/lib/boot2docker/bootlocal.sh"
}

dm_show_bootlocal_log() {
    dm_ssh "cat /var/log/bootlocal.log"
}
