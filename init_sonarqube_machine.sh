#!/bin/sh
progress_bar() {
  SECS=120
  while [[ 0 -ne $SECS ]]; do
    echo ".\c"
    sleep 1
    SECS=$[$SECS-1]
  done
  echo "\nTime is up, moving on."
}

echo "* Initializing SonarCube machine"
echo "** shutting boot2docker down"
boot2docker down
echo "** deleting existing boot2docker images"
boot2docker delete

echo "** initialize boot2docker"
boot2docker init

echo "** increasing boot2docker memory"
VBoxManage modifyvm boot2docker-vm --memory 2048
echo "** exposing sonarqube port to the outside world"
VBoxManage modifyvm boot2docker-vm --natpf1 'sonarqube-http-9000,tcp,,9000,,9000'
VBoxManage modifyvm boot2docker-vm --natpf1 'sonarqube-http-9092,tcp,,9092,,9092'

echo "** boot2docker startup"
boot2docker up --vbox-share=disable
$(boot2docker shellinit)
boot2docker ip

echo "* enable host nfs daemon for /Users"
echo "/Users -mapall=`whoami`:staff `boot2docker ip`\n" >> exports
sudo mv exports /etc && sudo nfsd restart
sleep 15

echo "* enable boot2docker nfs client"
boot2docker ssh 'echo -e "#! /bin/bash\n\
sudo mkdir /Users
sudo chown docker:staff /Users
# start nfs client
sudo /usr/local/etc/init.d/nfs-client start\n\
# mount /Users to host /Users
sudo mount 192.168.59.3:/Users /Users -o rw,async,noatime,rsize=32768,wsize=32768,proto=tcp\n\
" > ~/bootlocal.sh'
boot2docker ssh 'sudo cp ~/bootlocal.sh /var/lib/boot2docker/'
boot2docker ssh 'ls -ltra /var/lib/boot2docker/'
boot2docker ssh '. /var/lib/boot2docker/bootlocal.sh'
echo "* display mounted nfs share"
boot2docker ssh mount
boot2docker ssh 'ls -ltra /Users'

docker run --name=sonarqube --add-host nexus:192.168.8.31 --add-host jenkins:192.168.8.31 --add-host confluence:192.168.8.34 --add-host stash:192.168.8.31 -d -p 9000:9000 -p 9092:9092 sonarqube:latest
docker ps

echo "** setting docker timezone to EST"
ENV TZ=America/New_York

#echo "* wait for sonarqube to startup"
#progress_bar

echo "* sonarqube successfully started."
