#!/bin/sh

echo "updating boxen"

cd /opt/boxen/repo
git pull
git checkout ads
./script/boxen

. /opt/boxen/env.sh
