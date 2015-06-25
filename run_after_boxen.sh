#!/bin/sh

echo "* install command-line appium"
npm install -g appium

echo "* installing required gems"
sudo gem install appium_console
sudo gem install cocoapods
sudo gem install ocunit2junit

echo "* copy 'tailored' adroid-sdk from master"
mkdir -p /opt/boxen/homebrew/Cellar/android-sdk/tailored
cd /opt/boxen/homebrew/Cellar/android-sdk/tailored
scp -r ga-mlsdiscovery@192.168.8.61:/Users/ga-mlsdiscovery/tailored_backup/tailored_backup.tar .
tar xvf tailored_backup.tar
rm tailored_backup.tar

sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -off -restart -agent -privs -all -allowAccessFor -allUsers

sudo AppleFileServer
