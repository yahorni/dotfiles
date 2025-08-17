#!/usr/bin/env dash

set -eux

options="brave
Telegram
blueman-applet
steam
firefox
qutebrowser
transmission-da
qbittorrent
obsidian
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

option=$(echo "$running" | rofi -dmenu -i -p "Process to kill")
[ -z "$option" ] && exit 1

if pkill -fi --signal 9 "$option" ; then
    notify-send "$option killed"
else
    notify-send "Error while killing '$option'"
    exit 1
fi
