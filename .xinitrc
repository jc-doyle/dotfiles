#!/bin/sh

userresources=$HOME/.Xresources
if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

# Swapping Caps and Esc & Set Repeat Rate
xmodmap -e 'keysym Caps_Lock = Escape'
xmodmap -e 'clear Lock'
xsetroot -cursor_name left_ptr

# Turn off beep
xset -b

# Startup Scripts
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# Startup Programs
# syncthing --no-browser &
autorandr -c &
feh --no-fehbg --bg-scale /home/jonty/.cache/wallpaper/current.jpg &

# Configs conditioned on hostname
if [ "$(uname -n)" = "notebook" ]; then
    picom --config "$HOME"/.config/picom/mobile.conf &
else
    picom --config "$HOME"/.config/picom/box.conf &
fi

sxhkd &
"$HOME"/.config/polybar/launch.sh &

exec dwm
