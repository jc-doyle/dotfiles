# ALIASES
alias A="cat -s ~/.config/zsh/alias.zsh"

# Key Files 
alias af='nvim ~/.config/zsh/alias.zsh'
alias gl='nvim ~/.config/zsh/globals.zsh'
alias zs='nvim ~/.config/zsh/settings.zsh'
alias zp='nvim ~/.zprofile'

alias bs='nvim ~/.config/bspwm/bspwmrc'
alias sx='nvim ~/.config/sxhkd/sxhkdrc'
alias xi='nvim ~/.xinitrc'
alias al='nvim ~/.config/alacritty/alacritty.yml'
alias csd='nvim ~/other/dotfiles/colors/schemes/dark/dark.yaml'
alias csl='nvim ~/other/dotfiles/colors/schemes/light/light.yaml'

# Utilities
alias con="nmcli dev wifi con"
alias ls='ls -a --color=auto --format=vertical --sort=version'
alias feh='feh -B "#2e3440" --scale-down'
alias wallpaper='.scripts/setbg.sh'
alias sc='sc-im'
alias fonts='fc-list'

# Npm
alias npi="npm install -g"

# Switching
alias mobile='.config/autorandr/mobile/postswitch'
alias docked='.config/autorandr/docked/postswitch'

# Java
JAVA_OPTIONS='-Djava.util.prefs.userRoot="/home/jonty/.config/java" -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'

alias java='java $(echo $JAVA_OPTIONS)'
