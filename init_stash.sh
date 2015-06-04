#!/bin/sh

echo "***** Initializing Stash"
echo "** boot2docker setup"
boot2docker down
boot2docker delete

mkdir -p /Users/Shared/data/stash

boot2docker init

VBoxManage modifyvm boot2docker-vm --memory 8192
VBoxManage modifyvm boot2docker-vm --natpf1 'stash-http-7990,tcp,,7990,,7990'

echo "** boot2docker startup"
boot2docker up --vbox-share=disable
$(boot2docker shellinit)
boot2docker ip
echo "/Users -mapall=`whoami`:staff `boot2docker ip`" >> exports
sudo mv exports /etc && sudo nfsd restart
sleep 15

boot2docker ssh 'echo -e "#! /bin/bash\n\
sudo mkdir /Users
sudo chown docker:staff /Users
# start nfs client
sudo /usr/local/etc/init.d/nfs-client start\n\
# mount /Users to host /Users
sudo mount 192.168.59.3:/Users /Users -o rw,async,noatime,rsize=32768,wsize=32768,proto=tcp" > ~/bootlocal.sh'
boot2docker ssh 'sudo mv ~/bootlocal.sh /var/lib/boot2docker/'
boot2docker ssh 'ls -ltra /var/lib/boot2docker/'
boot2docker ssh '. /var/lib/boot2docker/bootlocal.sh'
boot2docker ssh mount
boot2docker ssh 'ls -ltra /Users'

echo "** docker stash startup"
docker run --name="stash" -d -v /Users/Shared/data/stash:/var/atlassian/application-data/stash -p 7990:7990 -p 7999:7999 atlassian/stash
docker ps

echo "** open stash browser"
open http://localhost:7990/
