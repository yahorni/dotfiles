#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

dunst &
compton --invert-color-include "class_i%=\"*_inverted_*\"" &
wal -Rn &
setwall &
unclutter &
sxhkd &

safeeyes &

xmodmap -e "keycode 135 = Super_R Menu"
xset r rate 220 40
xrdb -merge "$HOME/.Xresources"

exec i3
