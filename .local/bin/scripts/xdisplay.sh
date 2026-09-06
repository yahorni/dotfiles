#!/usr/bin/env bash
set -euo pipefail
check-binaries.sh xrandr rofi

# ignored when only a single screen detected as connected
declare -a modes=("1st" "2nd" "above" "below" "right" "left" "same")

## check available screens with `xrandr`
## eDP - laptop screen
declare -A screens=(
    [main]="eDP"
    [sub]="HDMI-A-0"
)
## check available devices with `ls /sys/class/drm/card*-*`
declare -A devices=(
    [main]="eDP-1"
    [sub]="HDMI-A-1"
)

main() {
    local mode="${1:-}"

    local main_status="$(cat "/sys/class/drm/card1-${devices["main"]}/status")"
    local sub_status="$(cat "/sys/class/drm/card1-${devices["sub"]}/status")"

    if [ "$main_status" == "connected" ] && [ "$sub_status" == "connected" ]; then
        if [ -z "$mode" ]; then
            mode="$(echo "${modes[@]}" | rofi -dmenu -sep ' ' -i -p "Display mode")"
        fi

        if [[ ! " ${modes[*]} " =~ $mode ]]; then
            echo "invalid mode" 1>&2
            exit 1
        fi

        case "$mode" in
            "1st")   xrandr --output "${screens["main"]}" --auto --primary --output "${screens["sub"]}" --off ;;
            "2nd")   xrandr --output "${screens["sub"]}" --auto --primary --output "${screens["main"]}" --off ;;
            "above") xrandr --output "${screens["main"]}" --auto --primary --output "${screens["sub"]}" --above    "${screens["main"]}" --auto ;;
            "below") xrandr --output "${screens["main"]}" --auto --primary --output "${screens["sub"]}" --below    "${screens["main"]}" --auto ;;
            "right") xrandr --output "${screens["main"]}" --auto --primary --output "${screens["sub"]}" --right-of "${screens["main"]}" --auto ;;
            "left")  xrandr --output "${screens["main"]}" --auto --primary --output "${screens["sub"]}" --left-of  "${screens["main"]}" --auto ;;
            "same")  xrandr --output "${screens["main"]}" --auto --primary --output "${screens["sub"]}" --same-as  "${screens["main"]}" --auto ;;
        esac
    else # single display
        xrandr --auto
    fi
}

main "$@"
