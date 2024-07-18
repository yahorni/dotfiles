#!/bin/bash

default_x=35
default_y=35
usage="Usage: ${0##*/} [-h] [-H left/right] [-v top/bottom] [-x percents] [-y percents]

-h — show help.
-H — attach window to left/right(default) corner.
-v — attach window to top/bottom(default) corner.
-x — 0..100 percents of the screen taken by window horizontally. Default = $default_x.
-y — 0..100 percents of the screen taken by window vertically. Default = $default_y.
"

warn_H="\-H option needs left/right value"
warn_v="\-v option needs top/bottom value"
warn_perc="option needs value between 0..100"
warn_num="option needs integer value"

warn() {
    notify-send "Warning" "$1"
    exit 1
}

num_regex='^[0-9]+$'

while getopts ":hH:v:x:y:" opt 2>/dev/null; do
    case "$opt" in
        h)  echo "$usage" && exit ;;
        H)  [ "$OPTARG" != "left" ] && [ "$OPTARG" != "right" ] && warn "$warn_H"
            x_pos=$OPTARG ;;
        v)  [ "$OPTARG" != "top" ] && [ "$OPTARG" != "bottom" ] && warn "$warn_v"
            y_pos=$OPTARG ;;
        x|y) ! [[ "$OPTARG" =~ $num_regex ]] && warn "\-$opt $warn_num"
            [ "$OPTARG" -lt 0 ] || [ "$OPTARG" -gt 100 ] && warn "\-$opt $warn_perc"
            if [ "$opt" = "x" ]; then
                x_perc=$OPTARG
            else
                y_perc=$OPTARG
            fi ;;
        *)  echo "invalid arg: '$opt'" && exit 1
    esac
done

x_position="${x_pos:-right}"
y_position="${y_pos:-bottom}"
x_percent="${x_perc:-default_x}"
y_percent="${y_perc:-default_y}"

pid=$(xdotool getwindowfocus)
geometry=($(xdotool getdisplaygeometry))

new_width=$((geometry[0] * x_percent / 100))
new_height=$((geometry[1] * y_percent / 100))
xdotool windowsize "$pid" $new_width $new_height

new_x=0
new_y=0
[ "$x_position" = "right" ] && new_x=$((geometry[0] - new_width))
[ "$y_position" = "bottom" ] && new_y=$((geometry[1] - new_height))

new_x=$((new_x + geometry[2] - 5))
new_y=$((new_y + geometry[3] - 5))

xdotool windowmove "$pid" $new_x $new_y
