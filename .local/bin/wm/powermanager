#!/bin/bash

options="🛑 poweroff <1>\n🔄 reboot <2>\n🌙 suspend <3>\n🔒 lock <4>\n📺 display off<5>\n💤 hibernate<6>"

if [ -n "$1" ]; then
    option="$1"
else
    option="$(echo -e "$options" | dmenu -i -p "Power manager:")"
fi

[ -z "$option" ] && exit

pause_prepare() {
    mpc pause >/dev/null 2>&1
}

case $option in
    *poweroff*)     systemctl poweroff ;;
    *reboot*)       reboot ;;
    *suspend*)      pause_prepare && systemctl suspend ;;
    *lock*)         lockscreen --dpms ;;
    *display*)      xset dpms force off ;;
    *hibernate*)    pause_prepare && systemctl hibernate ;;
    *)              notify-send "Power manager" "Incorrect option: '$option'" ;;
esac
