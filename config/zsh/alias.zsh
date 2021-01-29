# ALIASES
alias A="cat -s .config/zsh/alias.zsh"

# Key Files 
alias af='nvim ~/.config/zsh/alias.zsh'
alias gl='nvim ~/.config/zsh/globals.zsh'
alias zs='nvim ~/.zprofile'

alias bs='nvim ~/.config/bspwm/bspwmrc'
alias sx='nvim ~/.config/sxhkd/sxhkdrc'
alias xi='nvim ~/.xinitrc'
alias pi='nvim ~/.config/picom/picom.conf'
alias al='nvim ~/.config/alacritty/alacritty.yml'
alias xl='nvim ~/.local/share/xorg/Xorg.0.log'
alias pb='nvim ~/.config/polybar/config'
alias dn='nvim ~/.config/wal/templates/dunstrc'
alias vr='nvim ~/.config/nvim/init.vim' 

# Mail
alias mail="TERM=screen-256color neomutt"

# Utilities
alias con="nmcli dev wifi con"
alias ls='ls -a --color=auto --format=vertical --sort=version'
alias feh='feh -B "#2e3440" --scale-down'
alias wallpaper='.scripts/setbg.sh'

# Npm
alias npi="npm install -g"

# Switching
alias mobile='.config/autorandr/mobile/postswitch'
alias docked='.config/autorandr/docked/postswitch'
