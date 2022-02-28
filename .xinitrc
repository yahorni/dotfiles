#!/bin/bash

# nvidia card hacks
nvidia_lock="$XDG_DATA_HOME/nvidia_lock"
if [ -f "$nvidia_lock" ]; then
    echo "NVIDIA lock detected"
    xrandr --setprovideroutputsource modesetting NVIDIA-0
    xrandr --auto
fi

# autostart
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

# WM autostart
dwmbar &
dwmlistener.sh &
# sleep 5 && exec polybar -r notebar &

# Xorg settings
xwallpaper --stretch "$XDG_DATA_HOME/wallpaper"
xmodmap -e "keycode 135 = Super_R Menu"   # remap 'menu' button
xset r rate 200 35                        # keyboard speed
xsetroot -cursor_name left_ptr            # default cursor
xset s on                                 # enable screensaver
xset s 600                                # seconds before screensave
xrdb -merge "$XDG_CONFIG_HOME/Xresources" # apply xresources
# xss-lock -- physlock -ms &                # set screen lock

exec "$WM"
