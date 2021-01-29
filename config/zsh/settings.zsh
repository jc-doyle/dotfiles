# Key Speed
xset r rate 220 35

# History
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.cache/zsh/history
setopt INC_APPEND_HISTORY

# General
setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.

# Prompt Theme
fpath+="$HOME/.config/zsh/plugins/pure"
autoload -U promptinit; promptinit
prompt pure
setopt interactive_comments
PROMPT='%(?.%F{magenta}▧ .%F{red}▧ )%f '

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# ZLE hooks for prompt's vi mode status
function zle-line-init zle-keymap-select {
	# Change the cursor style depending on keymap mode.
	case $KEYMAP {
		vicmd)
			printf '\e[0 q' # Box.
			;;

		viins|main)
			printf '\e[6 q' # Vertical bar.
			;;
	}
}
zle -N zle-line-init
zle -N zle-keymap-select

# Less Colors
export LESS=-R
export LESS_TERMCAP_mb=$'\e[1;34m'
export LESS_TERMCAP_md=$'\e[3;34m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[1;35m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;32m'
