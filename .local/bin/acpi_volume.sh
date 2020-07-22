#!/bin/sh

acpi_listen | while read -r line ; do
    case "$line" in
        button/mute*)       pulsemixer --toggle-mute ;;
        button/volumeup*)   pulsemixer --change-volume +5 ;;
        button/volumedown*) pulsemixer --change-volume -5 ;;
    esac
done
