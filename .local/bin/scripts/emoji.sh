#!/usr/bin/env dash
set -eu
check-binaries.sh curl rofi xclip xdotool

emoji_path="${XDG_DATA_HOME:-$HOME/.local/share}/emoji.txt"
mode="${1:-copy}"

choose_emoji() { cut -d ';' -f1 "$emoji_path" | rofi -dmenu -p "Select emoji to $1" -i -l 15 | sed "s/ .*//" ; }

case "$mode" in
    "generate")
        curl "https://unicode.org/Public/emoji/latest/emoji-test.txt" -o /tmp/emoji.txt
        sed -n 's/^.*; fully-qualified\s\+\#\s*\(.*\) E[0-9]\+.[0-9]*/\1/p' /tmp/emoji.txt > "$emoji_path"
        echo "emoji generated: $(wc -l "$emoji_path")" 1>&2
        ;;
    "copy")
        chosen_emoji=$(choose_emoji "copy")
        if [ -z "$chosen_emoji" ]; then exit 0; fi
        echo -n "$chosen_emoji" | xclip -selection clipboard
        echo -n "$chosen_emoji" | xclip -selection primary
        ;;
    "type")
        chosen_emoji=$(choose_emoji "type")
        if [ -z "$chosen_emoji" ]; then exit 0; fi
        pid=$(xdotool getwindowfocus)
        xdotool type --window "$pid" "$chosen_emoji"
        ;;
    *)
        echo "usage: $0 <mode>"
        echo "  mode: generate/copy/type"
        exit 1
        ;;
esac
