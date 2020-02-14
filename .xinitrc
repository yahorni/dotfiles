#!/bin/sh

pgrep mpd || mpd &
dunst &
picom &
sxhkd &
unclutter &
clipmenud &

monitors=`xrandr --listmonitors | wc -l`
if [ $monitors -eq 2 ]; then
    suspender &
    transmission-daemon &
    redshift &

    xwallpaper --output eDP1 --stretch "$HOME/.local/share/wallpaper"
else
    safeeyes &

    xwallpaper \
        --output HDMI2 --stretch "$HOME/.local/share/wallpaper" \
        --output DP2 --stretch "$HOME/.local/share/vertical"
fi

xmodmap -e "keycode 135 = Super_R Menu"
xset r rate 200 35
xrdb -merge "$HOME/.Xresources"
xsetroot -cursor_name left_ptr
xset s on
xset s 600
xss-lock -- physlock -ms &

exec bspwm
