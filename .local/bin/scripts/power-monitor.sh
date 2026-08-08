#!/usr/bin/env bash
set -euo pipefail

suspend_delay_on_critical=15
check_period=45
low_level=15
critical_level=10

send_notification() {
    if [ -n "${DISPLAY:-}" ]; then
        notify-send -u critical -t 10000 "$1" "$2"
    else
        local msg="${2/\\n/, }"
        printf "%s: %s\n" "$1" "$msg"
    fi
}

get_battery_capacity() { cat /sys/class/power_supply/BAT0/capacity; }
get_battery_status() { cat /sys/class/power_supply/BAT0/status; }

while :; do
    capacity="$(get_battery_capacity)"
    status="$(get_battery_status)"

    [ "$status" != "Discharging" ] && return

    if [ "$capacity" -le "$critical_level" ]; then
        send_notification "Critically low battery" "$status, $capacity%\nSleep after $suspend_delay_on_critical sec"
        sleep "$suspend_delay_on_critical"

        capacity="$(get_battery_capacity)"
        status="$(get_battery_status)"

        if [ "$status" = "Discharging" ] && [ "$capacity" -le "$critical_level" ]; then
            systemctl suspend
        fi

    elif [ "$capacity" -le "$low_level" ]; then
        send_notification "Low battery" "$status, $capacity%"
    fi

    sleep "$check_period"
done
