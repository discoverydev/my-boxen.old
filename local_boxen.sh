#!/bin/sh

echo "setting up for boxen install"

# clear .gitconfig
cat /dev/null > /Users/admin/.gitconfig
more /Users/admin/.gitconfig

# remove keychain 
security delete-generic-password -s 'GitHub API Token'

cd /opt/boxen/repo
./script/boxen --no-fde --debug

. /opt/boxen/env.sh

boot2docker init
