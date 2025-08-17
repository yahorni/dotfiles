#!/usr/bin/env dash

set -eu

pgrep -x dunst >/dev/null

clipboard="$(xclip -o -selection clipboard 2>/dev/null || :)"
primary="$(xclip -o -selection primary 2>/dev/null || :)"

[ -z "$clipboard" ] && [ -z "$primary" ] && notify-send "Selections empty" && exit
notify-send "Selections" "<i>clipboard:</i> $clipboard\n<i>primary:</i> $primary"
