: ${DOCKER_VM_VBOXNET=vboxnet3}
: ${DOCKER_VM_NAME=boot2docker-vm}
: ${DOCKER_VM_MEMORY=2048}
: ${DOCKER_VM_CPUS=2}
: ${DOCKER_VM_HOST=`ifconfig $DOCKER_VM_VBOXNET | grep 'inet ' | cut -d ' ' -f 2`}
: ${DOCKER_VM_ARGS=}

b2d() {
    local command=$1
    boot2docker $command
}

dm_create() {
    b2d init
    VBoxManage modifyvm boot2docker-vm --memory "$DOCKER_VM_MEMORY"
    b2d start
    eval $( b2d shellinit )
    export DOCKER_VM_IP=$( b2d ip )
}

dm_start() {
    b2d up
    eval $( b2d shellinit )
    export DOCKER_VM_IP=$( b2d ip )
}

dm_stop() {
    b2d down
}

dm_delete() {
    dm_stop
    b2d delete
}

dm_ssh() {
    boot2docker $DOCKER_VM_ARGS ssh $1 $2 $3 $4 $5 $7 $8 $9
}

copy_to_dm_home() {
    local src=$1
    cat $src | boot2docker ssh "cat - >${src##*/}"
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
