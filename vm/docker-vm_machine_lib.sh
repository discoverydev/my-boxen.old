: ${DOCKER_DATA_DIR="/Users/Shared/data/$DOCKER_CONTAINER"}
: ${DOCKER_VM_NAME=docker-vm}
: ${DOCKER_VM_MEMORY=2048}
: ${DOCKER_VM_CPUS=2}
: ${DOCKER_VM_ARGS=}

dm() {
    local command=$1
    docker-machine $command $DOCKER_VM_NAME
}

dm_env() {
    eval $( dm env )
}

dm_create() {
    docker-machine create -d virtualbox $DOCKER_VM_NAME
    dm_env
    export DOCKER_VM_IP=$( dm ip )
}

dm_start() {
    dm_is_running
    if [[ $? == 1 ]]; then dm start; fi
    dm_env
    export DOCKER_VM_IP=$( dm ip )
}

dm_stop() {
    dm_is_running
    if [[ $? == 0 ]]; then dm stop; fi
}

dm_delete() {
    dm_stop
    dm_exists
    if [[ $? == 0 ]]; then dm rm; fi
}

# check $? after, 0=running, 1=not running
dm_is_running() {
    docker-machine status $DOCKER_VM_NAME 2>&1 | grep "Running" > /dev/null
}

# check $? after, 0=exists, 1=does not exist
dm_exists() {
    docker-machine status $DOCKER_VM_NAME 2>&1 | grep --invert-match "does not exist" > /dev/null
}

dm_ssh() {
    docker-machine $DOCKER_VM_ARGS ssh $DOCKER_VM_NAME $1 $2 $3 $4 $5 $7 $8 $9
}

copy_to_dm_home() {
    local src=$1
    local dest=$2
    docker-machine scp $src $DOCKER_VM_NAME:$2
}

dm_install_bootlocal() {
    local adapter=`VBoxManage showvminfo $DOCKER_VM_NAME | sed -n -e 's/^.*Host-only Interface //p' | cut -d \' -f2`
    local host_ip=`ifconfig $adapter | grep 'inet ' | cut -d ' ' -f 2`
    local bootlocal_file=/tmp/bootlocal${RANDOM}.sh
    generate_bootlocal $host_ip > $bootlocal_file
    dm_install_bootlocal_file $bootlocal_file
    rm $bootlocal_file
}

dm_install_bootlocal_file() {
    local bootlocal_file=$1
    copy_to_dm_home $bootlocal_file bootlocal.sh
    dm_ssh "chmod +x bootlocal.sh"
    dm_ssh "sudo mv bootlocal.sh /var/lib/boot2docker/"
    dm_ssh "sudo chown root:root /var/lib/boot2docker/bootlocal.sh"    
}

generate_bootlocal() {
    local host_ip=$1
    cat <<EOF 
echo "=== wait for host networking ($host_ip)"
EXIT_RESULT=1
while [ \${EXIT_RESULT} -gt 0 ]; do
    sleep 1
    ping -c 1 $host_ip > /dev/null 2>&1
    EXIT_RESULT=\$?
done
sleep 3
echo "=== start nfs"
sudo /usr/local/etc/init.d/nfs-client start
$(generate_bootlocal_mount "$host_ip:/Users" "/Users")
$(generate_bootlocal_mount "$host_ip:/opt/boxen" "/opt/boxen")
EOF
}

generate_bootlocal_mount() {
    local share=$1
    local mount_point=$2
    cat <<EOF
echo "=== remount $mount_point to $share using nfs"
sudo mkdir -p $mount_point
sudo chown docker:staff $mount_point
sudo umount $mount_point
sudo mount $share $mount_point -o rw,async,noatime,rsize=32768,wsize=32768,proto=tcp
mount | grep $mount_point
ls $mount_point
EOF
}

dm_run_bootlocal() {
    dm_ssh "/var/lib/boot2docker/bootlocal.sh"
}

dm_cat_bootlocal() {
    dm_ssh "cat /var/lib/boot2docker/bootlocal.sh"
}

dm_cat_bootlocal_log() {
    dm_ssh "cat /var/log/bootlocal.log"
}
