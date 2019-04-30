#!/bin/sh

if [ -f "$userresources" ]; then
    xrdb -merge "$HOME/.Xresources"
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

xmodmap -e "keycode 135 = Super_R Menu"
xset r rate 220 40
exec i3
