#!/bin/bash

# nvidia card hacks
nvidia_lock="$XDG_DATA_HOME/nvidia_lock"
if [ -f "$nvidia_lock" ]; then
    echo "NVIDIA lock detected"
    xrandr --setprovideroutputsource modesetting NVIDIA-0
    xrandr --auto
fi

# wallpaper
xwallpaper --stretch "$XDG_DATA_HOME/wallpaper"

# WM bar
if [ "$WM_BAR" = "dwmbar" ]; then
    dwmbar &
    dwmlistener.sh &
elif [ "$WM_BAR" = "polybar" ]; then
    sleep 10 && exec polybar -r notebar &
fi

# screenlock
# xss-lock -- physlock -ms &

# autostart
dunst &
picom &
sxhkd &
unclutter &
greenclip daemon &
pgrep -x suspender || suspender &
pgrep transmission-da || transmission-daemon &
nm-applet &

# safeeyes &
# redshift &
# blueman-applet &
