#!/usr/bin/env dash
set -eu
check-binaries.sh curl rofi xclip xdotool

emojis_path="${XDG_DATA_HOME:-$HOME/.local/share}/emojis.txt"

generate_emoji_list() {
    curl "https://unicode.org/Public/emoji/latest/emoji-test.txt" -o /tmp/emojis.txt
    sed -n 's/^.*; fully-qualified\s\+\#\s*\(.*\) E[0-9]\+.[0-9]*/\1/p' /tmp/emojis.txt > "$emojis_path"
    echo "emojis generated: $(wc -l "$emojis_path")" 1>&2
}

choose_emoji() {
    cut -d ';' -f1 "$emojis_path" | rofi -dmenu -i -l 15 | sed "s/ .*//"
}

mode="${1:-pick}"

if [ "$mode" = "gen" ]; then
    generate_emoji_list
elif [ "$mode" = "copy" ]; then
    chosen_emoji=$(choose_emoji)
    echo -n "$chosen_emoji" | xclip -selection clipboard
    echo -n "$chosen_emoji" | xclip -selection primary
    notify-send "'$chosen_emoji' copied"
elif [ "$mode" = "type" ]; then
    pid=$(xdotool getwindowfocus)
    xdotool type --window "$pid" "$(choose)"
else
    echo "usage: $0 <mode>"
    echo "  mode: gen/copy/type"
    exit 1
fi
