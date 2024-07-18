#!/bin/bash

low_message="Low battery"
critical_message="Critical battery"
remain_time=15
check_period=45
low_level=15
critical_level=7

send_notification() {
    if [ -n "$DISPLAY" ]; then
        notify-send -u critical -t 10000 "$1" "$2"
    else
        local msg="${2/\\n/, }"
        printf "%s: %s\n" "$1" "$msg"
    fi
}

get_battery_status() {
    acpi -b | awk -F'[,:%]' '{print $2, $3}'
}

check_acpi() {
    get_battery_status | {
        read -r status capacity

        [ "$status" != "Discharging" ] && return

        if [ "$capacity" -le "$critical_level" ]; then
            send_notification "$critical_message" "$status $capacity%\nRemain time: $remain_time sec"
            sleep $remain_time
            read -r new_status new_capacity < <(get_battery_status)
            [ "$new_status" = "Discharging" ] && [ "$new_capacity" -le "$critical_level" ] && systemctl suspend
        elif [ "$capacity" -le "$low_level" ]; then
            send_notification "$low_message" "$status $capacity%"
        fi
    }
}

while :; do
    check_acpi
    sleep $check_period
done
