#!/bin/bash

# nvidia card hacks
nvidia_lock="$XDG_DATA_HOME/nvidia_lock"
if [ -f "$nvidia_lock" ]; then
    xrandr --setprovideroutputsource modesetting NVIDIA-0
    xrandr --auto
fi

# autostart
dunst &
picom &
sxhkd &
unclutter &
clipmenud &
safeeyes &
suspender &
pgrep transmission-da || transmission-daemon &
redshift &

# WM autostart
if [ "$WM" = "dwm" ]; then
    dwmbar &
    dwmlistener.sh &
fi

# Xorg settings
xwallpaper --stretch "$XDG_DATA_HOME/wallpaper"
xmodmap -e "keycode 135 = Super_R Menu"   # remap 'menu' button
xset r rate 200 35                        # keyboard speed
xsetroot -cursor_name left_ptr            # default cursor
xset s on                                 # enable screensaver
xset s 600                                # seconds before screensave
xss-lock -- physlock -ms &                # set screen lock
xrdb -merge "$XDG_CONFIG_HOME/Xresources" # apply xresources

exec "$WM"
