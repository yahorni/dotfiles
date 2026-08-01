#!/usr/bin/env dash

set -eu

if ! command -v xwallpaper >/dev/null ; then
    notify-send "xwallpaper not found"
    exit 1
fi

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
    # no wallpaper found
    exit 1
fi

xwallpaper --stretch "$wallpaper"
