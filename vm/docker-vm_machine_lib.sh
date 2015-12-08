# uses DOCKER_VM_NAME, DOCKER_VM_USER 

host_adapter() {
    VBoxManage showvminfo $DOCKER_VM_NAME | sed -n -e 's/^.*Host-only Interface //p' | cut -d \' -f2    
}

host_ip() {
    ifconfig $(host_adapter) | grep 'inet ' | cut -d ' ' -f 2
}

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

dm_create_azure() {
    docker-machine create -d azure --azure-location "East US" --azure-subscription-id="add subcription id here" --azure-subscription-cert=/Users/ga-mlsdiscovery/azure_cert/mycert.pem $DOCKER_VM_NAME
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
    docker-machine ssh $DOCKER_VM_NAME $1 $2 $3 $4 $5 $7 $8 $9
}

dm_scp() {
    local src=$1
    local dest=$2
    docker-machine scp $src $DOCKER_VM_NAME:$2
}

dm_install_bootlocal() {
    local bootlocal_file=/tmp/bootlocal${RANDOM}.sh
    generate_bootlocal $(host_ip) > $bootlocal_file
    dm_install_bootlocal_file $bootlocal_file
    rm $bootlocal_file
}

dm_install_bootlocal_file() {
    local bootlocal_file=$1
    dm_scp $bootlocal_file bootlocal.sh
    dm_ssh "chmod +x bootlocal.sh"
    dm_ssh "sudo mv bootlocal.sh /var/lib/boot2docker/"
    dm_ssh "sudo chown root:root /var/lib/boot2docker/bootlocal.sh"    
}

dm_run_bootlocal() {
    dm_env
    dm_ssh "/var/lib/boot2docker/bootlocal.sh"
}

dm_cat_bootlocal() {
    dm_ssh "cat /var/lib/boot2docker/bootlocal.sh"
}

dm_cat_bootlocal_log() {
    dm_ssh "cat /var/log/bootlocal.log"
}

launchd_install() {
    local plist_file=~/Library/LaunchAgents/docker.$DOCKER_VM_NAME.plist
    generate_launchd_plist $(host_ip) > $plist_file  
    launchctl load -wF $plist_file
}

launchd_uninstall() {
    local plist_file=~/Library/LaunchAgents/docker.$DOCKER_VM_NAME.plist
    if [[ -f $plist_file ]]; then
        launchctl unload $plist_file
        rm $plist_file
    fi
}

##
## data generators
##

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
sudo /usr/local/etc/init.d/nfs-client restart &>/dev/null

if [[ "$DOCKER_CONTAINER_DATA_DIR" != "" ]]; then
    $(generate_bootlocal_mount "$host_ip:/Users" "/Users")
    $(generate_bootlocal_mount "$host_ip:/opt/boxen" "/opt/boxen")
fi

EOF
}

generate_bootlocal_mount() {
    local share=$1
    local mount_point=$2
    cat <<EOF
echo "=== mount $mount_point to $share using nfs"
sudo umount -f $mount_point &>/dev/null
sudo mkdir -p $mount_point
sudo chown docker:staff $mount_point
sudo mount $share $mount_point -o rw,async,noatime,rsize=32768,wsize=32768,proto=tcp
mount | grep $mount_point
EOF
}

generate_launchd_plist() {
    cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>KeepAlive</key>
    <true/>
    <key>Label</key>
    <string>docker.$DOCKER_VM_NAME</string>
    <key>ProgramArguments</key>
    <array>
      <string>docker-machine</string>
      <string>start</string>
      <string>$DOCKER_VM_NAME</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>UserName</key>
    <string>$DOCKER_VM_USER</string>
    <key>WorkingDirectory</key>
    <string>/Users/$DOCKER_VM_USER</string>
    <key>StandardErrorPath</key>
    <string>/usr/local/var/log/$DOCKER_VM_NAME.log</string>
    <key>StandardOutPath</key>
    <string>/usr/local/var/log/$DOCKER_VM_NAME.log</string>
  </dict>
</plist>
EOF
}

