#!/bin/dash

mode="${1:-rofi}"

case "$mode" in
    dmenu)
        greenclip print | sed '/^$/d' | dmenu -i -l 10 | xargs -r -d'\n' -I '{}' greenclip print '{}'
        ;;
    rofi)
        rofi -modi "clipboard:greenclip print" -show clipboard -run-command '{cmd}'.
        ;;
esac
