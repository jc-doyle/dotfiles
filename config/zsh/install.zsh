#!/bin/zsh

mkcd() {
  mkdir -p "$1"
  cd "$1" || exit
}

# Cloning Zsh-Plugins
mkcd plugins 
rm -rf pure zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting zsh-vi-mode

echo "Installing Zsh Plugins..."
git clone https://github.com/sindresorhus/pure.git
git clone https://github.com/zsh-users/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-history-substring-search.git
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
git clone https://github.com/jeffreytse/zsh-vi-mode

echo "Removing Pure newline..."
sed -i '/spacious/{n;s/print//}' pure/pure.zsh

mkdir -p $HOME/.cache/zsh/ || exit
echo "Complete. Create a history file."
