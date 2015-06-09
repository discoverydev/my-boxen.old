#!/bin/sh

echo "** shutting boot2docker down"
boot2docker down
echo "* deleting any existing boot2docker images"
boot2docker delete

DATA_DIR=/Users/Shared/data
rm -rf $DATA_DIR

sudo /usr/bin/dscl . -delete "/Users/jenkins"

rm -rf ~/src
rm -rf ~/VirtualBox\ VMs/
rm -rf ~/.boot2docker/
rm -rf ~/.jenkins/
rm -rf ~/.subversion/
rm -rf ~/.gemrc
rm -rf ~/.CFUserTextEncoding
rm -rf /opt/homebrew-cask
rm -rf ~/rubies

cd /opt/boxen/repo
./script/nuke --force --all
rm -rf /opt/boxen
