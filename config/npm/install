#!/bin/zsh

# Install Node Packages
set -e
sed 's/#.*//' pkglist.txt | xargs npm install -g || exit
