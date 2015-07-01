#!/bin/sh
progress_bar() {
  SECS=120
  while [[ 0 -ne $SECS ]]; do
    echo "$SECS..\r"
    sleep 1
    SECS=$[$SECS-1]
  done
  echo "Time is up, moving on."
}

$(boot2docker shellinit)
echo "** shutting boot2docker down"
boot2docker down

echo "** boot2docker startup"
boot2docker up --vbox-share=disable
boot2docker ip

echo "* enable host nfs daemon for /Users"
echo "/Users -mapall=`whoami`:staff `boot2docker ip`\n" >> exports
# the /opt/boxen nfs mount is required for jenkins to find android sdk
echo "* enable host nfs daemon for /opt/boxen"
echo "/opt/boxen -mapall=`whoami`:staff `boot2docker ip`\n" >> exports
sudo mv exports /etc && sudo nfsd restart
sleep 15

#echo "* enable boot2docker nfs client"
#boot2docker ssh 'sudo cp ~/bootlocal.sh /var/lib/boot2docker/'
boot2docker ssh 'ls -ltra /var/lib/boot2docker/'
boot2docker ssh '. /var/lib/boot2docker/bootlocal.sh'
echo "* display mounted nfs share"
boot2docker ssh mount
boot2docker ssh 'ls -ltra /Users'

echo "* defining directory for data shares (must be under the above nfs share)"
DATA_DIR=/Users/Shared/data

echo "** docker stash startup"
docker restart stash
docker ps

echo "** docker nexus startup"
docker restart nexus
docker ps

echo "* wait for stash to startup"
progress_bar

echo "** docker jenkins startup"
echo "* using existing jenkins data dir"
docker restart jenkins
docker ps

echo "** open stash browser"
open http://localhost:7990/
echo "** open nexus browser"
open http://localhost:8081/
echo "** open jenkins browser"
open http://localhost:8080/
