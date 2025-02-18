#!/bin/bash

systemctl --user import-environment DISPLAY XAUTHORITY
systemctl --user start dunst

# current systemd services:
# - dunst
# - acpi-volume
# - greenclip
# - redshift
# - syncthing
# - playerctld

programs=(
    # installed
    "picom"
    "sxhkd"
    "unclutter"
    "nm-applet"

    # custom
    "dwmbar"
    "xdisplay.sh"
    "set-wallpaper.sh"
    "remapd.sh"
)

for program in "${programs[@]}"; do
    if command -v "$program" && ! pidof -sx "$(echo "$program" | cut -d' ' -f1)" ; then
        $program &
    fi
done
