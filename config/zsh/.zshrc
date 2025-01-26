# Settings & Aliases
source "$HOME/.config/zsh/settings.zsh"
source "$HOME/.config/zsh/alias.zsh"
source "$HOME/.config/zsh/fzfcolors.zsh"
source "$HOME/.config/zsh/functions.zsh"

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

# bun completions
[ -s "/home/jonty/.bun/_bun" ] && source "/home/jonty/.bun/_bun"
