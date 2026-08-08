#!/bin/sh
set -eu

# skip locking for non-laptop chassis
if [ "$(hostnamectl chassis)" != "laptop" ]; then
    exit 0
fi

mode="${1:-daemon}"
lock_image="${XDG_DATA_HOME:-${HOME}/.local/share}/wallpaper"
lock_command=(i3lock -i "$lock_image")

case "$mode" in
    daemon) exec xss-lock --transfer-sleep-lock -- "${lock_command[@]}" --nofork ;;
    once)   exec "${lock_command[@]}" ;;
esac
