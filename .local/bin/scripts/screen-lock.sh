#!/bin/sh
set -eu

mode="${1:-daemon}"
lock_image="${XDG_DATA_HOME:-${HOME}/.local/share}/wallpaper"
lock_command=(i3lock -i "$lock_image")

case "$mode" in
    daemon) exec xss-lock --transfer-sleep-lock -- "${lock_command[@]}" --nofork ;;
    once)   exec "${lock_command[@]}" ;;
esac
