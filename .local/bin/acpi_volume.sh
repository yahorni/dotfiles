#!/bin/dash

acpi_listen | while read -r line ; do
    case "$line" in
        button/mute*)       pamixer --toggle-mute ;;
        button/volumeup*)   pamixer --increase 3 --allow-boost ;;
        button/volumedown*) pamixer --decrease 3 --allow-boost ;;
    esac
done
