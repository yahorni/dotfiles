#!/usr/bin/env dash
set -eu
check-binaries.sh xclip

clipboard="$(xclip -o -selection clipboard 2>/dev/null || :)"
primary="$(xclip -o -selection primary 2>/dev/null || :)"

notify-send -r 6324 "Clipboard (${#clipboard} chars)" "$clipboard"
notify-send -r 6325 "Primary (${#primary} chars)" "$primary"
