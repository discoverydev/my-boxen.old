#!/bin/bash
if [ "$USER" != "root" ]; then echo "This script must be run with sudo"; exit -1; fi

nfsd_restart() {
    echo "=== restarting nfsd"
    nfsd checkexports
    nfsd update
    nfsd restart
    sleep 5
}

nfsd_configure() {
    nfs_conf_line="nfs.server.mount.require_resv_port=0"
    grep "$nfs_conf_line" /etc/nfs.conf > /dev/null
    if [ "$?" != "0" ]; then
      $(cp -n /etc/nfs.conf /etc/nfs.conf.prev) && echo "Backed up /etc/nfs.conf to /etc/nfs.conf.prev"
      echo "$nfs_conf_line" >> /etc/nfs.conf
    fi
}

nfsd_map_share() {
    local guest_ip=$1
    local guest_network=$(echo $guest_ip | cut -d"." -f1-3).0
    local guest_user=$2
    local host_share=$3
    echo "=== mapping $host_share for $guest_user to network $guest_network"
    local exports_line="${host_share} -mapall=${guest_user}:staff -network ${guest_network}"
    # check to see if the exports line is already in the file
    grep "$exports_line" /etc/exports > /dev/null
    if [ "$?" != "0" ]; then
      # backup the existing exports
      $(cp -n /etc/exports /etc/exports.prev) && echo "Backed up /etc/exports to /etc/exports.prev"
      # keep everything but the host_share name
      grep -v "^${host_share} " /etc/exports > /tmp/exports
      # append the new host_share exports line
      echo "$exports_line" >> /tmp/exports
      # put it back
      mv /tmp/exports /etc
    fi
}

nfsd_configure
guest_ip=$1
guest_user=$2
shift 2
for share in "$@"; do
    nfsd_map_share ${guest_ip} ${guest_user} ${share}
done
nfsd_restart
