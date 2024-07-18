#!/bin/bash

filedate="$(date +%Y-%m-%d_%H-%M-%S-%N).png"
pix=$(xdg-user-dir PICTURES)
screendir="$pix/screens"
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
