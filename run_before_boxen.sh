#!/bin/sh

#USER=ga-mlsdiscovery
USER=ga-mlsdiscovery
SERVER=192.168.8.29

source ~/.profile

echo "* adding $SERVER to known_hosts"
ssh-keyscan $SERVER > ~/.ssh/known_hosts

TARFILE=boxen.tar
DEST=/opt
SRC=/opt

echo "* copy $TARFILE from $SERVER ($SRC) to $DEST"
mkdir -p $DEST

pushd $DEST
echo "  user $USER"
rsync -ru --progress $USER@$SERVER:$SRC/$TARFILE $DEST/$TARFILE
tar xkvf $TARFILE
popd
