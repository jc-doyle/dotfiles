# ALIASES
alias A="cat -s ~/.config/zsh/alias.zsh"

# Key Files 
alias todo='nvim ~/university/TODO.md'
alias hist='nvim ~/.cache/zsh/history'
alias af='nvim ~/.config/zsh/alias.zsh'
alias al='nvim ~/.config/zsh/alias.zsh'
alias ki='nvim ~/.config/kitty/kitty.conf'
alias zs='nvim ~/.config/zsh/settings.zsh'
alias lfrc='nvim ~/.config/lf/lfrc'
alias zp='nvim ~/other/dotfiles/.zprofile'

alias bs='nvim ~/.config/bspwm/bspwmrc'
alias dw='nvim ~/.config/dwm/config.def.h'
alias sx='nvim ~/.config/sxhkd/sxhkdrc'
alias xi='nvim ~/.xinitrc'
alias csd='nvim ~/other/dotfiles/colors/schemes/dark/dark.yaml'
alias csl='nvim ~/other/dotfiles/colors/schemes/light/light.yaml'

# Utilities
alias s="kitty +kitten ssh"
alias doc="~/.local/share/pandoc/newdoc/newdoc.py"
alias con="nmcli dev wifi con"
alias ls='ls -A --color=auto --format=vertical -X --group-directories-first'
alias feh='feh -B "#2e3440" --scale-down'
alias wallpaper='.scripts/setbg.sh'
alias gf='git status'
alias light='sudo light -S'
alias mixer='pulsemixer'
alias rsync='rsync --info=progress2'
alias m='mysql -uroot --auto-rehash'
alias poweroff='sudo systemctl poweroff'
# alias lf='/usr/share/lf/lfcd.sh'

# Fonts
alias fonts='fc-list -f "%{family[0]} - %{style}\n" | sort | uniq | fzf'

# Browser Apps
alias notebook='jupyter notebook --browser="/usr/bin/chromium --app=%s"'
alias diagram='chromium --app="https://app.diagrams.net"'
alias docs='chromium --app="https://docs.google.com/document/u/0/"'
alias sheets='chromium --app="https://docs.google.com/spreadsheets/"'
alias figma='chromium --app="https://www.figma.com/"'
alias via='sudo chown $USER:$USER /dev/hidraw2 && chromium --app="https://usevia.app/"'

# Npm
alias npi="npm install -g"

# Python
# alias pip="pip3"

# Switching
alias mobile='.config/autorandr/mobile/postswitch'
alias docked='.config/autorandr/docked/postswitch'

# Java
JAVA_OPTIONS='-Djava.util.prefs.userRoot="/home/jonty/.config/java" -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'
alias java='java $(echo $JAVA_OPTIONS)'

# Hledger
alias hl='hledger --color=always --pretty=yes'
alias income-statement='hl is --tree'
alias balance-sheet='hl bs --tree'
