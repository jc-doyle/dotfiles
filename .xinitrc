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

# XrandR setup
autorandr -c &

# Startup Scripts
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# Start DWM
exec dwm 2> "$XDG_CACHE_HOME"/dwm.log
