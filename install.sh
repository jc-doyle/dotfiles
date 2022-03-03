#!/bin/sh
echo "Please ensure you have created a user (a sudoer), and are logged in as that user."

# Set Config

# Pacman Things
grep -q "ILoveCandy" /etc/pacman.conf || sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf
sed -i "s/^#ParallelDownloads = 8$/ParallelDownloads = 5/;s/^#Color$/Color/" /etc/pacman.conf
sed -i "s/-j2/-j$(nproc)/;s/^#MAKEFLAGS/MAKEFLAGS/" /etc/makepkg.conf

# Install Yay
echo "Installing Yay"
git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin 
sudo makepkg --noconfirm -si
cd .. && rm -r yay-bin
