# ALIASES
alias A="cat -s ~/.config/zsh/alias.zsh"

# Key Files 
alias todo='nvim ~/university/TODO.md'
alias hist='nvim ~/.cache/zsh/history'
alias af='nvim ~/.config/zsh/alias.zsh'
alias al='nvim ~/.config/zsh/alias.zsh'
alias gl='nvim ~/.config/zsh/globals.zsh'
alias zs='nvim ~/.config/zsh/settings.zsh'
alias lfrc='nvim ~/.config/lf/lfrc'
alias zp='nvim ~/.zprofile'

alias bs='nvim ~/.config/bspwm/bspwmrc'
alias dw='nvim ~/.config/dwm/config.def.h'
alias sx='nvim ~/.config/sxhkd/sxhkdrc'
alias xi='nvim ~/.xinitrc'
alias csd='nvim ~/other/dotfiles/colors/schemes/dark/dark.yaml'
alias csl='nvim ~/other/dotfiles/colors/schemes/light/light.yaml'

# Utilities
alias doc="~/.local/share/pandoc/newdoc/newdoc.py"
alias con="nmcli dev wifi con"
alias ls='ls -A --color=auto --format=vertical -X --group-directories-first'
alias feh='feh -B "#2e3440" --scale-down'
alias wallpaper='.scripts/setbg.sh'
alias gf='git status'
# alias lf='/usr/share/lf/lfcd.sh'

#Fonts
alias fonts='fc-list -f "%{family[0]} - %{style}\n" | sort | uniq | fzf'

#Notebook
alias notebook='jupyter notebook --browser="/usr/bin/chromium --app=%s"'

#Sheets
alias sheets='devour chromium --app="https://docs.google.com/spreadsheets/"'

# Npm
alias npi="npm install -g"

# Switching
alias mobile='.config/autorandr/mobile/postswitch'
alias docked='.config/autorandr/docked/postswitch'

# Java
JAVA_OPTIONS='-Djava.util.prefs.userRoot="/home/jonty/.config/java" -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'
alias java='java $(echo $JAVA_OPTIONS)'
