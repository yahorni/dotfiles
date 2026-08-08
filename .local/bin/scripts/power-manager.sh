#!/usr/bin/env dash
set -eu
check-binaries.sh rofi xset

options="\
🛑 1. poweroff
🔄 2. reboot
🌙 3. suspend
🔒 4. lock
📺 5. display off
💤 6. hibernate
⚙️ 7. bios"

if [ -n "${1:-}" ]; then
    option="$1"
else
    option="$(echo "$options" | rofi -dmenu -i -p "Power manager")"
fi

[ -z "$option" ] && exit

pause_players() {
    if command -v playerctl >/dev/null ; then
        playerctl pause || :
    fi
    if pgrep -f mpd >/dev/null && command -v mpc >/dev/null ; then
        mpc pause >/dev/null 2>&1
    fi
    if pgrep supersonic >/dev/null && command -v supersonic-desktop ; then
        supersonic-desktop -pause
    fi
}

case $option in
    *poweroff*)     systemctl poweroff ;;
    *reboot*)       systemctl reboot ;;
    *suspend*)      pause_players ; systemctl suspend ;;
    *lock*)         lockscreen --dpms ;;
    *display*)      xset dpms force off ;;
    *hibernate*)    pause_players ; systemctl hibernate ;;
    *bios*)         systemctl reboot --firmware-setup ;;
    *)              notify-send "Power manager" "Incorrect option: '$option'" ;;
esac
