#!/usr/bin/env dash
set -eu
check-binaries.sh rofi

options="brave
Telegram
blueman-applet
steam
firefox
librewolf
qutebrowser
transmission-daemon
qbittorrent
onboard
nm-applet
mpv
picom"

is_first=1
running=""
for item in $(echo "$options"); do
    pgrep -fi "$item" >/dev/null && \
        if [ $is_first -eq 0 ]; then
            running="$running\n$item"
        else
            running="$item"
            is_first=0
        fi
done

option=$(echo "$running" | rofi -dmenu -i -p "Process to terminate")
[ -z "$option" ] && exit 1

if pkill --full "$option" ; then
    notify-send "$option terminated"
else
    notify-send "Failed to terminate '$option'"
    exit 1
fi
