#!/bin/sh

#USER=ga-mlsdiscovery
USER=admin
SERVER=192.168.8.31

echo "* adding $SERVER to known_hosts"
ssh-keyscan $SERVER > ~/.ssh/known_hosts

TARFILE=tailored_backup.tar
DEST=/opt/android-sdk
SRC=/Users/$USER/tailored_backup

echo "* copy $TARFILE from $SERVER ($SRC) to $DEST"
mkdir -p $DEST

pushd $DEST
echo "  user $USER"
scp -r $USER@$SERVER:$SRC/$TARFILE .
tar xvf $TARFILE
rm $TARFILE
popd
