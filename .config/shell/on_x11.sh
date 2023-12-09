#!/bin/bash

# nvidia card hacks
if lsmod | grep "nvidia" ; then
    xrandr --setprovideroutputsource modesetting NVIDIA-0
    xrandr --auto

    # configure dpi
    xrandr --dpi 96
fi

# configure monitors
xdisplay.sh

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
autostart=(
    "dunst"
    "picom"
    "sxhkd"
    "unclutter"
    "greenclip daemon"
    "suspender"
    "transmission-daemon"
    "nm-applet"
    "redshift -l 53.893009:27.567444"
    "remapd"
)

for program in "${autostart[@]}"; do
    pidof -sx "$(echo "$program" | cut -d' ' -f1)" || $program &
done >/dev/null 2>&1
