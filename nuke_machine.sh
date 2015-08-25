#!/bin/sh

echo "** shutting boot2docker down"
boot2docker down
echo "* deleting any existing boot2docker images"
boot2docker delete

echo "* quitting any running instances of VirtualBox"
osascript -e 'quit app "VirtualBox"'

echo "* shutting down local jenkins instance"
curl --silent --request POST "http://localhost:8080/exit"

DATA_DIR=/Users/Shared/data

echo "** deleting local user : jenkins"
sudo dscl . -delete "/Users/jenkins"
sudo rm /Users/jenkins

read -p "do you want to delete the 'src' directory?: (Y/n)" DELETE_SRC
DELETE_SRC=${DELETE_SRC:-y}

if [ "$DELETE_SRC" = y ]
then
  echo "** deleting directory : ~/src"
  rm -rf ~/src
else
  echo "* keeping 'src' directory."
fi

echo "** deleting virtual box images"
rm -rf ~/VirtualBox\ VMs/
echo "** deleting boot2docker directory"
rm -rf ~/.boot2docker/
echo "** deleting jenkins directories"
rm -rf ~/.jenkins/
rm -rf ~/jenkins_slave/
echo "** deleting .subversion directory"
rm -rf ~/.subversion/
echo "** deleting rubies directory"
rm -rf ~/rubies
echo "** deleting .m2"
rm -rf ~/.m2/

echo "** deleting homebrew-cast directory"
rm -rf /opt/homebrew-cask
echo "** deleting android-sdk"
rm -rf /opt/android-sdk
echo "** deleting android-sdk"
rm -rf /opt/android-sdk
echo "** deleting mockability-server"
rm -rf /opt/mockability-server
echo "** deleting dynatrace"
rm -rf /opt/dynatrace

echo "** deleting various dot files"
rm -rf ~/.gemrc ~/.CFUserTextEncoding ~/.profile ~/.gitignore ~/.gitconfig ~/.viminfo ~/.lesshst


echo "** nuking boxen install"
cd /opt/boxen/repo
./script/nuke --force --all
rm -rf /opt/boxen

echo "** removing brew cache"
rm $(brew --cache)/Formula/*

cd ~
