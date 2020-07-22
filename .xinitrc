#!/bin/bash

nvidia_lock="$XDG_DATA_HOME/nvidia_lock"

if [ -f "$nvidia_lock" ]; then
    xrandr --setprovideroutputsource modesetting NVIDIA-0
    xrandr --auto
fi

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

if [ "$WM" = "dwm" ]; then
    dwmbar &
    dwmlistener.sh &
fi

xmodmap -e "keycode 135 = Super_R Menu"   # remap 'menu' button
xset r rate 200 35                        # keyboard speed
xsetroot -cursor_name left_ptr            # default cursor
xset s on                                 # enable screensaver
xset s 600                                # seconds before screensave
xss-lock -- physlock -ms &                # set screen lock
xrdb -merge "$XDG_CONFIG_HOME/Xresources" # apply xresources

exec "$WM"
