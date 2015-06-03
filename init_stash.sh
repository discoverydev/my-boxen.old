#!/bin/sh

echo "initializing stash"

echo "/Users -mapall=`whoami`:staff `boot2docker ip`" >> exports
sudo mv exports /etc && sudo nfsd restart

mkdir -p /Users/Shared/data/stash

boot2docker init

VBoxManage sharedfolder remove boot2docker-vm --name Users
VBoxManage modifyvm boot2docker-vm --memory 8192

boot2docker start --vbox-share=disable
VBoxManage controlvm "boot2docker-vm" natpf1 "stash-http-7990,tcp,,7990,,7990"

# docker run -u root -v /Users/Shared/data/stash:/var/atlassian/application-data/stash atlassian/stash chown -R daemon  /var/atlassian/application-data/stash

docker run --name="stash" -d -v /Users/Shared/data/stash:/var/atlassian/application-data/stash -p 7990:7990 -p 7999:7999 atlassian/stash

docker ps

open http://localhost:7990/
