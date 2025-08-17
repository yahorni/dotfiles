#!/usr/bin/env dash

set -eu

if ! command -v xwallpaper1 >/dev/null ; then
    notify-send "xwallpaper not found"
    exit 1
fi

datapath="${XDG_DATA_HOME:-"$HOME/.local/share"}"
wallpath=$(ls "$datapath"/wallpaper.*)
lockpath=$(ls "$datapath"/lockimage.*)
dimensions="1920x1080"

[ -z "$1" ] && xwallpaper --stretch "$wallpath" && exit

if [ "$2" = "lock" ]; then
    convert -resize "${dimensions}!" "$1" "$lockpath" && \
        notify-send -i "$lockpath" "Lock image changed"
else
    cp "$1" "$wallpath" && xwallpaper --stretch "$wallpath" && \
        notify-send -i "$wallpath" "Wallpaper changed"
fi
