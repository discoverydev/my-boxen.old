#!/bin/sh

echo "* install command-line appium"
npm install -g appium

echo "* installing required gems"
sudo gem install appium_console
sudo gem install ocunit2junit
