#!/bin/bash -l

# update brew
./brew_update_pre_boxen.sh

echo "creating boxen tar"
set +e

echo "remove log files"
rm -rf /opt/boxen/log/
cd /opt
tar cvf boxen.tar --exclude='boxen.tar' .

# This will obtain the return status of the last command (boxen)
RESULT=$?
echo "boxen tar creation completed with the following exit code : " $RESULT

if [ $RESULT -eq 0 ] 
then
    echo "Boxen tar was created successfully."
    echo "Sending results to Jenkins."
    curl http://jenkins/job/Boxen_Tar_Create/buildWithParameters?CALLER=BOXEN
    . /opt/boxen/env.sh
else 
    echo "Boxen tar was NOT created successfully."
    exit 1
fi

