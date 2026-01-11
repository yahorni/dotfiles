#!/usr/bin/env dash

set -eu

pgrep -x dunst >/dev/null

CLIPBOARD="$(xclip -o -selection clipboard 2>/dev/null || :)"
PRIMARY="$(xclip -o -selection primary 2>/dev/null || :)"

notify-send -r 6324 "Clipboard (${#CLIPBOARD})" "$CLIPBOARD"
notify-send -r 6325 "Primary (${#PRIMARY})" "$PRIMARY"
