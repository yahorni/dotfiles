#!/bin/bash

# nvidia card hacks
nvidia_lock="$XDG_DATA_HOME/nvidia_lock"
if [ -f "$nvidia_lock" ]; then
    echo "NVIDIA lock detected"
    xrandr --setprovideroutputsource modesetting NVIDIA-0
    xrandr --auto
fi

dunst &
picom &
sxhkd &
unclutter &
greenclip daemon &
suspender &
pgrep transmission-da || transmission-daemon &
nm-applet &

# safeeyes &
# redshift &
# blueman-applet &

xwallpaper --stretch "$XDG_DATA_HOME/wallpaper"
xrdb -merge "$XDG_CONFIG_HOME/Xresources" # apply xresources
# xss-lock -- physlock -ms &                # set screen lock

# WM bar
if [ "$WMBAR" = "dwmbar" ]; then
    dwmbar &
    dwmlistener.sh &
elif [ "$WMBAR" = "polybar" ]; then
    sleep 10 && exec polybar -r notebar &
fi

# xmodmap binds
for _ in $(seq 1 10); do
    xmodmap "$XDG_CONFIG_HOME/xmodmaprc"
    sleep 5s
done &
