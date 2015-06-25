#!/bin/sh

echo "* install command-line appium"
npm install -g appium

echo "* installing required gems"
sudo gem install appium_console
sudo gem install cocoapods
sudo gem install ocunit2junit

echo "* copy 'tailored' adroid-sdk from master"
cd /opt/boxen/homebrew/Cellar/android-sdk/
scp -r admin@192.168.8.31:/Users/admin/tailored_backup/tailored_backup.tar .
tar xvf tailored_backup.tar
rm tailored_backup.tar

sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -off -restart -agent -privs -all -allowAccessFor -allUsers

sudo AppleFileServer
