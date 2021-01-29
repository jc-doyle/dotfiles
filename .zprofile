export PATH="$HOME/.cargo/bin:$PATH"
export PATH="~/.local/bin/:$PATH"
export PATH="~/.scripts/:$PATH"

# Programs
export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="firefox"

# XDG Defaults
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Home Clean Up
export GTK2_RC_FILES="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-2.0/gtkrc-2.0"
export LESSHISTFILE="-"
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
export ANDROID_SDK_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/android"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"

# LF icons
source "$HOME/.config/zsh/lficons.zsh"
