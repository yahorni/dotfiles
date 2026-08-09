#!/bin/sh
set -euo pipefail

status="$(playerctl status 2>&1 | tr '[:upper:]' '[:lower:]' || true)"
IFS='' read -r artist title length position <<< \
    "$(playerctl metadata -f "{{ artist }}{{ title }}{{ duration(mpris:length) }}{{ duration(position) }}" 2>/dev/null)"

if [ "$status" = "playing" ] || [ "$status" = "paused" ]; then
    header="$title"
    if [ -n "$artist" ]; then
        body="by <i>$artist</i>"
    fi
    if [ -n "$length" ]; then
        body="$body\n[$position/$length]"
    fi
else
    header="$status"
fi
notify-send -r 2435 -t 5000 "🎵 $header" "${body:-}"
