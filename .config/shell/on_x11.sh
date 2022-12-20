#!/bin/bash

# nvidia card hacks
if lsmod | grep "nvidia" ; then
    xrandr --setprovideroutputsource modesetting NVIDIA-0
    xrandr --auto
fi

# second monitor detection
if xrandr | grep "HDMI1 connected" ; then
    xrandr --output HDMI1 --auto --primary --output eDP1  --right-of HDMI1
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
redshift -l "53.893009:27.567444" &
