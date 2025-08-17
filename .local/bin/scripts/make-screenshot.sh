#!/usr/bin/env dash

set -eu

if ! command -v maim >/dev/null ; then
    notify-send "maim not found"
    exit 1
fi

filedate="$(date +%Y-%m-%d_%H-%M-%S-%N).png"
pix=$(xdg-user-dir PICTURES)
screendir="$pix/screens/$(date +%Y)"
[ ! -d "$screendir" ] && mkdir -p "$screendir"
filename="$screendir/$filedate"

if [ "$1" = 'part' ]; then
    maim -s -u "$filename"
elif [ "$1" = 'window' ]; then
    maim -B -u -i "$(xdotool getactivewindow)" "$filename"
else
    maim -B -u "$filename"
fi

copy-image.sh "$filename"
