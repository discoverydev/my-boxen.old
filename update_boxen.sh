#!/bin/bash -l

echo "updating boxen and pushing result to Jenkins"

set +e
cd /opt/boxen/repo
git checkout ads
git pull
./script/boxen workstation

# This will obtain the return status of the last command (boxen)
RESULT=$?
echo $RESULT

############################
# boxen uses Puppet's feature of '--detailed-exitcodes' and extends the standard '0' exit code on success
#   - an exit code of '0' means success and no changes
#   - an exit code of '2' means there were changes, 
#   - an exit code of '4' means there were failures during the transaction, and 
#   - an exit code of '6' means there were both changes and failures.
############################
if [ $RESULT -eq 0 ] || [ $RESULT -eq 2 ]
then
    echo "Boxen was updated successfully."
    echo "Sending results to Jenkins."
    curl http://jenkins/job/Boxen_$(hostname -s)/buildWithParameters?CALLER=BOXEN
    . /opt/boxen/env.sh
else 
    echo "Boxen was NOT updated successfully."
    exit 1
fi

# update brew
./brew_update_post_boxen.sh

