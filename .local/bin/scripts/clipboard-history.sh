#!/bin/dash

mode="${1:-rofi}"
manager="${2:-clipmenu}"

if [ "$manager" = "clipmenu" ]; then
    case "$mode" in
        dmenu) CM_LAUNCHER=dmenu clipmenu ;;
        rofi)  CM_LAUNCHER=rofi  clipmenu ;;
    esac
elif [ "$manager" = "greenclip" ]; then
    case "$mode" in
        dmenu)
            greenclip print | sed '/^$/d' | dmenu -i -l 10 |\
            xargs -r -d'\n' -I '{}' greenclip print '{}'
            ;;
        rofi)
            rofi -modi "clipboard:greenclip print" -show clipboard -run-command '{cmd}'.
            ;;
    esac
fi
