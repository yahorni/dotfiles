#!/bin/dash
command -v xkb-switch >/dev/null && xkb-switch -s us
dmenu -p "$1" -nf black -nb black -sf black -sb darkgrey <&-
