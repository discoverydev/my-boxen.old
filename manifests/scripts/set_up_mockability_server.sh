#! /bin/bash

MOCKABILITY_HOME=/opt/mockability-server
VERSION=1.0-SNAPSHOT

if [[ -d $MOCKABILITY_HOME ]]; then
    exit 0
fi

rm -rf $MOCKABILITY_HOME
mkdir -p $MOCKABILITY_HOME
curl "https://5dad5f463fe4f2a465f0c3643236c95f98d91337.googledrive.com/host/0B7jYzSKu2fmPfmstNkxxTEItSzZiR3VFdW5TVkpVNjE3aTNwSktrbk1mVFNTTUc5aGxoQ1U/mockability-server-$VERSION.zip" >$MOCKABILITY_HOME/mockability-server.zip
unzip $MOCKABILITY_HOME/mockability-server.zip -d $MOCKABILITY_HOME
rm $MOCKABILITY_HOME/mockability-server.zip

ln -s $MOCKABILITY_HOME/mockability-server-$VERSION/bin/mockability-server /usr/local/bin/mockability-server
exit 0
