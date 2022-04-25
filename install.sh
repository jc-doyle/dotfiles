#!/bin/sh
set -e
DOTFOLDER="$HOME/other/dotfiles"
PKGLIST="$DOTFOLDER/pkglist.txt"

echo "Please ensure you have created a user (a sudoer), and are logged in as that user."
cd "$HOME" || exit

# Set Config

# Pacman Things
sudo grep -q "ILoveCandy" /etc/pacman.conf || sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf
sudo sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 5/;s/^#Color$/Color/" /etc/pacman.conf
sudo sed -i "s/-j2/-j$(nproc)/;s/^#MAKEFLAGS/MAKEFLAGS/" /etc/makepkg.conf

# Install Yay
echo "Installing Yay..."
git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin || exit
makepkg --noconfirm -si

# Cloning Zsh-Plugins
cd "$DOTFOLDER"/config/zsh/plugins || exit
echo "Installing Zsh Plugins..."
git clone https://github.com/sindresorhus/pure.git
git clone https://github.com/zsh-users/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-history-substring-search.git
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
git clone https://github.com/jeffreytse/zsh-vi-mode

# Install from pkglist
echo "Installing Packages..."
cd "$DOTFOLDER" || exit
yay -S --needed $(< "$PKGLIST")

# Update config
$DOTFOLDER/scripts/update-config
