#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# Swapping Caps and Esc & Set Repeat Rate
xmodmap -e 'keysym Caps_Lock = Escape'
xmodmap -e 'clear Lock'

# Idea
export _JAVA_AWT_WM_NONREPARENTING=1

# Cursor
xsetroot -cursor_name left_ptr

# Scaling
WINIT_X11_SCALE_FACTOR=1
# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# Background Init Programs
exec bspwm 
