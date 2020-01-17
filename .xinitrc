#!/bin/sh

dunst &
picom &
unclutter &
sxhkd &
clipmenud &
transmission-daemon &
mpd &

setwall &

redshift &
# safeeyes &

xmodmap -e "keycode 135 = Super_R Menu"
xset r rate 200 35
xrdb -merge "$HOME/.Xresources"

xset s on
xset s 600
xss-lock -- physlock -ms &

xsetroot -cursor_name left_ptr

exec bspwm
