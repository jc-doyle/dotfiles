# Key Speed

if [[ $DISPLAY ]]; then
  xset r rate 220 35
fi

# History
# To clear duplicates run [awk '!seen[$0]++' filename]
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.cache/zsh/history
setopt INC_APPEND_HISTORY

# General
setopt autocd		# Automatically cd into typed directory.
setopt interactive_comments
stty stop undef		# Disable ctrl-s to freeze terminal.

# Prompt Theme
fpath+="$ZDOTDIR/plugins/pure"
autoload -U promptinit; promptinit
prompt pure
PURE_PROMPT_SYMBOL='⊳'
PURE_PROMPT_VICMD_SYMBOL='⊲'
zstyle :prompt:pure:path color blue
zstyle :prompt:pure:virtualenv color '#3A4458'
zstyle :prompt:pure:git:branch color '#7887A6'
zstyle :prompt:pure:git:branch color '#7887A6'
zstyle :prompt:pure:user color '#5E6A83'
zstyle :prompt:pure:host color red


#PROMPT='%(?.%F{magenta}⊳.%F{red}⊳)%f '

# Basic auto/tab complete:
zstyle ':completion:*' menu select
zmodload zsh/complist
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi
_comp_options+=(globdots)		# Include hidden files.

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

bindkey -a -r ':'
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[[Z' vi-up-line-or-history

# Less Colors
export LESS=-R
export LESS_TERMCAP_mb=$'\e[1;34m'
export LESS_TERMCAP_md=$'\e[3;34m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[0;95m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;32m'

#Vi Mode
ZVM_VI_HIGHLIGHT_BACKGROUND=#3A4458

#Highlighting
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red'
ZSH_HIGHLIGHT_STYLES[comment]='fg=white'
zle_highlight+=(region:'bg=#3A4456')

#Should Concatenate ?
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=#3A4458'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=#9ADBFF'

# Plugins
source "$ZDOTDIR/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh" 
source "$ZDOTDIR/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

function zvm_after_init() {
  zvm_bindkey viins '^K' history-substring-search-up
  zvm_bindkey viins '^J' history-substring-search-down
}
