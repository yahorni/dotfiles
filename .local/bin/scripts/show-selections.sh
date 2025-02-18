#!/bin/bash

pgrep -x dunst || exit 1

clipboard=$(xclip -o -selection clipboard)
primary=$(xclip -o -selection primary)

[ -z "$clipboard" ] && [ -z "$primary" ] && \
    notify-send "Selections" "empty" && exit

notify-send "Selections" "<i>clipboard:</i> $clipboard\n<i>primary:</i> $primary"
