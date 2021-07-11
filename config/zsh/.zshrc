# Settings & Aliases
source "$HOME/.config/zsh/settings.zsh"
source "$HOME/.config/zsh/alias.zsh"
source "$HOME/.config/zsh/fzfcolors.zsh"

# Plugins
source "$HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# LF
source "/usr/share/lf/lfcd.sh"
bindkey -s '^o' 'lfcd\n'
