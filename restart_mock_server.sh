#!/bin/sh
progress_bar() {
  SECS=30
  while [[ 0 -ne $SECS ]]; do
    echo ".\c"
    sleep 1
    SECS=$[$SECS-1]
  done
  echo "\nTime is up, moving on."
}

# sleeping in order to allow the box to stabilize before the script starts
progress_bar

export PATH=/opt/boxen/homebrew/bin:$PATH
export DOCKER_HOST=tcp://192.168.59.103:2376
export DOCKER_CERT_PATH=/Users/ga-mlsdiscovery/.boot2docker/certs/boot2docker-vm
export DOCKER_TLS_VERIFY=1

echo "* Restarting mockserver"
echo "** shutting boot2docker down"
boot2docker down

echo "** boot2docker startup"
boot2docker up
boot2docker ip
eval "$(boot2docker shellinit)"

echo "* defining directory for data shares"
DATA_DIR=/Users/Shared/data

echo "** docker mockserver startup"
docker --tlsverify=false restart mockserver
docker ps

echo "* wait for mockserver to startup"
progress_bar

echo "** open mockserver browser"
open http://localhost:9001/message
