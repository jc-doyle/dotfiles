# Locale
export LANG=C.UTF-8

# Programs
export EDITOR="nvim"
export TERMINAL="alacritty"
export PAGER="less"
export BROWSER="firefox"

# XDG Defaults
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Path
export PATH="$HOME/.local/bin/:$PATH"
export PATH="$HOME/.scripts/:$PATH"
export PATH="$GOPATH/bin/:$PATH"
export PATH="$XDG_DATA_HOME/npm/bin:$PATH"
export PATH="/usr/bin/julia:$PATH"
export PATH="$XDG_DATA_HOME/texlive/bin/x86_64-linux/:$PATH"
export PATH="$XDG_CONFIG_HOME/polybar/:$PATH"

# Colors
# export COLOR_DIR=$HOME/other/dotfiles/colors/

# Home Clean Up
export JUPYTERLAB_DIR=$HOME/.local/share/jupyter/lab
export GTK2_RC_FILES="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-2.0/gtkrc-2.0"
export LESSHISTFILE="-"
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
export ANDROID_SDK_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/android"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
export _JAVA_AWT_WM_NONREPARENTING=1
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export VSCODE_PORTABLE="$XDG_DATA_HOME"/vscode
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export OCTAVE_HISTFILE="$XDG_CACHE_HOME/octave-hsts"
export OCTAVE_SITE_INITFILE="$XDG_CONFIG_HOME/octave/octaverc"
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk"
export IPYTHONDIR="$XDG_CONFIG_HOME"/ipython
export PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME"/cpython
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME"/jupyter
export PYLINTHOME="$XDG_CACHE_HOME"/pylint
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export JULIA_DEPOT_PATH="$XDG_DATA_HOME/julia:$JULIA_DEPOT_PATH"
export R_PROFILE="~/.config/R/profile.R"
export R_LIBS_USER="~/.local/share/R/libraries/"
export STACK_ROOT="$XDG_DATA_HOME"/stack
export TEXMFHOME=$XDG_DATA_HOME/texmf
export TEXMFVAR=$XDG_CACHE_HOME/texlive/texmf-var
export TEXMFCONFIG=$XDG_CONFIG_HOME/texlive/texmf-config
export PYTHONSTARTUP=$XDG_CONFIG_HOME/python/startup.py
export CONDARC="$XDG_CONFIG_HOME/conda/condarc"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME"/pass
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export __GL_SHADER_DISK_CACHE_PATH=$XDG_CACHE_HOME/nv/
export CUDA_CACHE_PATH=$XDG_CACHE_HOME/nvidia/compute

# LF Icons
LF_ICONS=$(sed ~/.config/lf/icons \
            -e '/^[ \t]*#/d'      \
            -e '/^[ \t]*$/d'      \
            -e 's/[ \t]\+/=/g'    \
            -e 's/$/ /')
LF_ICONS=${LF_ICONS//$'\n'/:}
LF_ICONS=$(echo $LF_ICONS | tr -d '[:space:]')
export LF_ICONS
