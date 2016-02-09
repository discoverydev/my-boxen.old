#!/bin/bash -l

echo "updating brew"
brew -v update
echo "upgrading  brew"
brew -v upgrade --all
echo "cleaning up old versions"
brew -v cleanup
