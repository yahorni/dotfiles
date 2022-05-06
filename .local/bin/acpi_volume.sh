#!/bin/dash

acpi_listen | while read -r line ; do
    case "$line" in
        button/mute*)       pamixer -t ;;
        button/volumeup*)   pamixer -i 3 ;;
        button/volumedown*) pamixer -d 3 ;;
    esac
done
