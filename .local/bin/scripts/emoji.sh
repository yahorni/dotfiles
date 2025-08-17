#!/usr/bin/env dash

set -eu

emojis_path="${XDG_DATA_HOME:-$HOME/.local/share}/emojis.txt"

generate() {
    curl "https://unicode.org/Public/emoji/latest/emoji-test.txt" -o /tmp/emojis.txt
    sed -n 's/^.*; fully-qualified\s\+\#\s*\(.*\) E[0-9]\+.[0-9]*/\1/p' /tmp/emojis.txt > "$emojis_path"
    echo "emojis generated: $(wc -l "$emojis_path")" 1>&2
}

choose() {
    cut -d ';' -f1 "$emojis_path" | rofi -dmenu -i -l 15 | sed "s/ .*//"
}

mode="${1:-pick}"

if [ "$mode" = "gen" ]; then
    generate
elif [ "$mode" = "copy" ]; then
    chosen=$(choose)
    echo -n "$chosen" | xclip -selection clipboard
    echo -n "$chosen" | xclip -selection primary
    notify-send "'$chosen' copied"
elif [ "$mode" = "type" ]; then
    pid=$(xdotool getwindowfocus)
    xdotool type --window "$pid" "$(choose)"
else
    echo "usage: $0 <mode>"
    echo "  mode: gen/copy/type"
    exit 1
fi
