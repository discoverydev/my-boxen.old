#!/bin/bash -l

echo "updating boxen and pushing result to Jenkins"

set +e
cd /opt/boxen/repo
git checkout ads
git pull
./script/boxen

# This will obtain the return status of the last command (boxen)
RESULT=$?
echo $RESULT

# boxen does not follow the UNIX standard of 'all non-zero return codes are failures..."
if [ $RESULT -eq 2 ] || [ $RESULT -eq 6 ] || [ $RESULT -eq 4 ] || [ $RESULT -eq 0 ]
then
    echo "Boxen was updated successfully."
    echo "Sending results to Jenkins."
    curl http://jenkins/job/Boxen_$(hostname -s)/buildWithParameters?CALLER=BOXEN
    . /opt/boxen/env.sh
else
    echo "Boxen was NOT updated successfully."
    exit 1
fi

