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

echo "* Initializing Build machine"
echo "** shutting boot2docker down"
boot2docker down
echo "** deleting existing boot2docker images"
boot2docker delete

echo "** initialize boot2docker"
boot2docker init

echo "** increasing boot2docker memory"
VBoxManage modifyvm boot2docker-vm --memory 2048
echo "** exposing tomcat port to the outside world"
VBoxManage modifyvm boot2docker-vm --natpf1 'tomcat-http-8888,tcp,,8888,,8888'

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

echo "* defining directory for data shares (must be under the above nfs share)"
DATA_DIR=/Users/Shared/data
mkdir -p $DATA_DIR

echo "** docker tomcat startup"
if [ "$#" -eq 1 ] && [ -f $1 ]
then
  echo "* base tomcat image provided -> untar'ing $1 to $DATA_DIR/tomcat"
  rm -rf $DATA_DIR/tomcat
  mkdir -p $DATA_DIR/tomcat
  cd $DATA_DIR/tomcat
  tar xvf $1 
else
  echo "* base tomcat image NOT provided -> assuming default"
  mkdir -p $DATA_DIR/tomcat/webapps/sample-checkout
fi
docker run -d -p 8888:8080 --name tomcat -v $DATA_DIR/tomcat/webapps/sample-checkout:/usr/local/tomcat/webapps/sample-checkout tomcat:8.0
#docker run --name=tomcat -d -v $DATA_DIR/tomcat:/var/local/atlassian/tomcat -p 8090:8090 cptactionhank/atlassian-tomcat:latest
docker ps

echo "** setting docker timezone to EST"
ENV TZ=America/New_York

echo "* wait for tomcat to startup"
progress_bar

echo "** open tomcat browser"
open http://localhost:8888/
