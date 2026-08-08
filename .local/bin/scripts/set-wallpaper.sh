#!/usr/bin/env dash
set -eu
check-binaries.sh xwallpaper

wallpaper="${XDG_DATA_HOME:-"$HOME/.local/share"}/wallpaper"

# set new wallpaper if argument given
if [ -n "${1:-}" ]; then
    cp "$1" "$wallpaper"
    xwallpaper --stretch "$wallpaper"
    notify-send -i "$wallpaper" "Wallpaper changed"
    exit 0
fi

# restore current wallpaper
if [ ! -f "$wallpaper" ]; then
    exit 1 # no wallpaper found
fi

xwallpaper --stretch "$wallpaper"
