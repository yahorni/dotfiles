#!/usr/bin/env bash

datapath="${XDG_DATA_HOME:-"$HOME/.local/share"}"
wallpath="$datapath/wallpaper"
lockpath="$datapath/lockimage"
dimensions="1920x1080"

[ -z "$1" ] && xwallpaper --stretch "$wallpath" && exit

if [ "$2" = "lock" ]; then
    convert -resize "${dimensions}!" "$1" "$lockpath" && \
        notify-send -i "$lockpath" "Lock image changed"
else
    cp "$1" "$wallpath" && xwallpaper --stretch "$wallpath" && \
        notify-send -i "$wallpath" "Wallpaper changed"
fi
