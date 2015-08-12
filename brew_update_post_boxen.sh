#!/bin/bash -l

echo "updating brew"
brew update
echo "upgrading  brew"
brew upgrade --all
echo "cleaning up old versions"
brew cleanup