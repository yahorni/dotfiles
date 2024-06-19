#!/bin/bash

options="chromium
telegram-deskto
blueman-applet
steam
viber
firefox
qutebrowser
transmission-da
qbittorrent
greenclip
nm-applet
picom"

is_first=1
items=""
for item in $(echo -e "$options"); do
    pgrep -fi "$item" >/dev/null && \
        if [ $is_first -eq 0 ]; then
            items="$items\n$item"
        else
            items="$item"
            is_first=0
        fi
done

item=$(echo -e "$items" | dmenu -i -p "Which one to kill?")
[[ "$?" -eq "1" ]] && exit 1
[[ -z $item ]] && exit 1
pkill -fi --signal 9 "$item"
[[ "$?" -eq "0" ]] && notify-send "$item terminated" && exit 0
notify-send "Error while terminating $item" && exit 1
