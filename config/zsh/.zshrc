# Settings & Aliases
source "$HOME/.config/zsh/settings.zsh"
source "$HOME/.config/zsh/alias.zsh"
source "$HOME/.config/zsh/fzfcolors.zsh"

# Plugins
source "$HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# LF
 source "/usr/share/lf/lfcd.sh"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/jonty/.local/lib/miniconda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/jonty/.local/lib/miniconda/etc/profile.d/conda.sh" ]; then
        . "/home/jonty/.local/lib/miniconda/etc/profile.d/conda.sh"
    else
        export PATH="/home/jonty/.local/lib/miniconda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

