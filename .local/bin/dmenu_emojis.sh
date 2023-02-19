#!/bin/bash

emojis_path="${XDG_DATA_HOME:-$HOME/.local/share}/emojis"
chosen=$(cut -d ';' -f1 "$emojis_path" | dmenu -i -l 15 | sed "s/ .*//")

[ -z "$chosen" ] && exit 1

if [ "$#" -eq 0 ]; then
    echo -n "$chosen" | xclip -selection clipboard
    echo -n "$chosen" | xclip -selection primary
    notify-send "'$chosen' copied"
else
    xdotool type "$chosen"
fi
