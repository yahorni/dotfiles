#!/bin/bash

options="🛑 poweroff <1>\n🔄 reboot <2>\n🌙 suspend <3>\n🔒 lock <4>\n📺 display off<5>\n💤 hibernate<6>\n⚙️ bios<7>"

if [ -n "$1" ]; then
    option="$1"
else
    option="$(echo -e "$options" | dmenu -i -p "Power manager:")"
fi

[ -z "$option" ] && exit

pause_players() {
    if command -v playerctl >/dev/null ; then
        playerctl pause
    else
        pgrep -f mpd && command -v mpc >/dev/null && mpc pause >/dev/null 2>&1
        pgrep supersonic && command -v supersonic-desktop && supersonic-desktop -pause
    fi
}

case $option in
    *poweroff*)     systemctl poweroff ;;
    *reboot*)       reboot ;;
    *suspend*)      pause_players ; systemctl suspend ;;
    *lock*)         lockscreen --dpms ;;
    *display*)      xset dpms force off ;;
    *hibernate*)    pause_players ; systemctl hibernate ;;
    *bios*)         systemctl reboot --firmware-setup ;;
    *)              notify-send "Power manager" "Incorrect option: '$option'" ;;
esac
