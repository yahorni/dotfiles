#!/bin/bash

[ "$(pgrep -x acpi_volume.sh | wc -l)" -gt 2 ] && exit 1

acpi_listen | while read -r line ; do
    case "$line" in
        button/mute*)       pulsemixer --toggle-mute ;;
        button/volumeup*)   pulsemixer --change-volume +3 ;;
        button/volumedown*) pulsemixer --change-volume -3 ;;
    esac
done
