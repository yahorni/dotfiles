#!/bin/bash

pgrep -x dunst || exit 1

clipboard=$(xclip -o -selection clipboard)
primary=$(xclip -o -selection primary)

[ -z "$clipboard" ] && [ -z "$primary" ] && \
    notify-send "Empty selections" && exit

[ -n "$clipboard" ] && notify-send "Clipboard" "$clipboard"
[ -n "$primary" ] && notify-send "Primary" "$primary"
