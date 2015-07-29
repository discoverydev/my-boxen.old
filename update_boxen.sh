#!/bin/bash -l

echo "updating boxen"

set +e
cd /opt/boxen/repo
git checkout ads
git pull
./script/boxen

RESULT=$?
echo $RESULT

if [ $RESULT -eq 2 ] || [ $RESULT -eq 6 ] || [ $RESULT -eq 4 ] || [ $RESULT -eq 0 ]
then
    echo "success"
    curl http://jenkins/job/Boxen_$(hostname -s)/buildWithParameters?CALLER=BOXEN
    . /opt/boxen/env.sh
else
    echo "failure"
    exit 1
fi

