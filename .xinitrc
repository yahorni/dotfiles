#!/bin/sh

pgrep mpd || mpd &
dunst &
picom &
sxhkd &
unclutter &
clipmenud &

transmission-daemon &
redshift &

xwallpaper --output eDP1 --stretch "$HOME/.local/share/wallpaper"

xmodmap -e "keycode 135 = Super_R Menu"
xset r rate 200 35
xrdb -merge "$HOME/.Xresources"
xsetroot -cursor_name left_ptr
xset s on
xset s 600
xss-lock -- physlock -ms &

exec bspwm
