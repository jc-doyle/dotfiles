#!/bin/sh
set -e
DOTFOLDER="$HOME/other/dotfiles"
PKGDIR="$DOTFOLDER/pkg"
PKGLIST="$PKGDIR/pkg"
AURLIST="$PKGDIR/aur"
NODELIST="$PKGDIR/node"

echo "Please ensure you have created a user (a sudoer), and are logged in as that user."
cd "$HOME" || exit

# Pacman Things
sudo grep -q "ILoveCandy" /etc/pacman.conf || sudo sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf
sudo sed -Ei "s/^#(ParallelDownloads).*/\1 = 5/;/^#Color$/s/#//" /etc/pacman.conf
sudo sed -i "s/-j2/-j$(nproc)/;s/^#MAKEFLAGS/MAKEFLAGS/" /etc/makepkg.conf

# Install Yay
echo "Installing Yay..."
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin || exit
makepkg --noconfirm -si

# Zsh Install
echo "Installing Zsh Goodies..."
cd "$DOTFOLDER"/config/zsh/ || exit
zsh install.zsh

# Install from pkglist
echo "Installing Packages..."
cd "$DOTFOLDER" || exit
sudo pacman -S --needed - < "$PKGLIST"
yay -S --needed $(< "$AURLIST")

# Update config
echo "Updating Config..."
$DOTFOLDER/scripts/update-config

#echo "Installing Python Goodies.."
#cd "$DOTFOLDER"/config/python/ || exit
#zsh install.zsh

#echo "Installing Node Goodies.."
#cd "$DOTFOLDER"/config/npm/ || exit
#zsh install.zsh

