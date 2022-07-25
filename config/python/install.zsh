#!/bin/zsh

# Install Python
echo "Fetching Pip bootstrap file.."
curl -O https://bootstrap.pypa.io/get-pip.py || exit
python get-pip.py || exit
pip3 install -r "pkglist.txt"

# Remove get-pip
echo "Removing Pip..."
rm get-pip.py || exit

echo "Python Libraries & Binaries installed."
