#!/bin/sh
progress_bar() {
  SECS=12
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

echo "* Restarting Tomcat machine"
echo "** shutting boot2docker down"
boot2docker down

echo "** boot2docker startup"
boot2docker up
$(boot2docker shellinit)
boot2docker ip

echo "** docker tomcat startup"
docker --tlsverify=false restart tomcat
docker --tlsverify=false ps

echo "* wait for tomcat to startup"
progress_bar

echo "** open tomcat browser"
open http://localhost:8888/
