#!/bin/bash

# for debugging:
# exec >>/tmp/script.log 2>&1
# set -xu

mode="${1:-horizontal}"

declare -a modes=("vertical" "horizontal" "same" "hdmi")

if [[ ! " ${modes[*]} " =~ $mode ]]; then
    echo "invalid mode"
    exit 1
fi

HDMI_STATUS="$(cat "/sys/class/drm/card"*"-HDMI-A-1/status")"

max_attempts=20
attempt=1
while ! xrandr | grep -q "HDMI. $HDMI_STATUS"; do
    sleep 1s
    attempt=$((attempt + 1))
    [ "$attempt" -gt "$max_attempts" ] && break
done

if [ "$HDMI_STATUS" == "connected" ]; then
    if [ "$mode" == "vertical" ]; then
        xrandr --output HDMI1 --auto --primary --output eDP1 --below HDMI1 --auto
    elif [ "$mode" == "same" ]; then
        xrandr --output HDMI1 --auto --primary --output eDP1 --same-as HDMI1 --auto
    elif [ "$mode" == "hdmi" ]; then
        xrandr --output HDMI1 --auto --primary --output eDP1 --off
    else # horizontal
        xrandr --output HDMI1 --auto --primary --output eDP1 --right-of HDMI1 --auto
    fi
else # only laptop display
    xrandr --auto
fi
