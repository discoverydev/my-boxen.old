#!/bin/sh

echo "* install command-line appium"
npm install -g appium

echo "* installing required gems"
sudo gem install appium_console
sudo gem install ocunit2junit

echo "* copy 'tailored' adroid-sdk from master"
cd /opt/boxen/homebrew/Cellar/android-sdk/
scp -r admin@192.168.8.4:/opt/boxen/homebrew/Cellar/android-sdk/tailored .
