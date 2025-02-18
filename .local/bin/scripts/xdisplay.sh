#!/bin/bash

declare -a modes=("1st" "2nd" "above" "below" "right" "left" "same")
declare -A scrns conns
scrns["1st"]="DP2"
conns["1st"]="DP-2"
scrns["2nd"]="HDMI1"
conns["2nd"]="HDMI-A-1"

check_xrandr() {
    local screen="$1"
    local status="$2"

    max_attempts=10
    attempt=1
    while ! xrandr | grep -q "$screen $status"; do
        sleep 1s
        attempt=$((attempt + 1))
        [ "$attempt" -gt "$max_attempts" ] && break
    done
}

main() {
    mode="${1:-1st}"
    shift

    if [[ ! " ${modes[*]} " =~ $mode ]]; then
        echo "invalid mode" 1>&2
        exit 1
    fi

    local _1st_status _2nd_status
    _1st_status="$(cat "/sys/class/drm/card1-${conns["1st"]}/status")"
    _2nd_status="$(cat "/sys/class/drm/card1-${conns["2nd"]}/status")"

    check_xrandr "${scrns["2nd"]}" "$_2nd_status"

    if [ "$_1st_status" == "connected" ] && [ "$_2nd_status" == "connected" ]; then
        case "$mode" in
            "1st")   xrandr --output "${scrns["1st"]}" --auto --primary --output "${scrns["2nd"]}" --off ;;
            "2nd")   xrandr --output "${scrns["2nd"]}" --auto --primary --output "${scrns["1st"]}" --off ;;
            "above") xrandr --output "${scrns["1st"]}" --auto --primary --output "${scrns["2nd"]}" --above    "${scrns["1st"]}" --auto ;;
            "below") xrandr --output "${scrns["1st"]}" --auto --primary --output "${scrns["2nd"]}" --below    "${scrns["1st"]}" --auto ;;
            "right") xrandr --output "${scrns["1st"]}" --auto --primary --output "${scrns["2nd"]}" --right-of "${scrns["1st"]}" --auto ;;
            "left")  xrandr --output "${scrns["1st"]}" --auto --primary --output "${scrns["2nd"]}" --left-of  "${scrns["1st"]}" --auto ;;
            "same")  xrandr --output "${scrns["1st"]}" --auto --primary --output "${scrns["2nd"]}" --same-as  "${scrns["1st"]}" --auto ;;
        esac
    else # single display
        xrandr --auto
    fi
}

main "$@"
