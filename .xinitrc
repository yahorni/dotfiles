#!/bin/bash

nvidia_lock="$XDG_DATA_HOME/nvidia_lock"

if [ -f "$nvidia_lock" ]; then
    xrandr --setprovideroutputsource modesetting NVIDIA-0
    xrandr --auto
fi

pgrep mpd || mpd &
dunst &
picom &
sxhkd &
unclutter &
clipmenud &
safeeyes &

monitors=`xrandr --listmonitors | wc -l`
if [ $monitors -eq 2 ]; then
    suspender &
    pgrep transmission-da || transmission-daemon &
    redshift &

    xwallpaper --stretch "$XDG_DATA_HOME/wallpaper"
else
    xwallpaper \
       --output HDMI2 --stretch "$XDG_DATA_HOME/wallpaper" \
       --output DP2 --stretch "$XDG_DATA_HOME/vertical"
fi

xmodmap -e "keycode 135 = Super_R Menu"
xset r rate 200 35
xrdb -merge "$XDG_CONFIG_HOME/Xresources"
xsetroot -cursor_name left_ptr
xset s on
xset s 600
xss-lock -- physlock -ms &

# DWM
dwmbar &
dwmlistener.sh &
exec dwm
