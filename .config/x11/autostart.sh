j!/bin/bash

systemctl --user import-environment DISPLAY XAUTHORITY

# current systemd services:
# - clipmenud
# - dunst (can't be enabled, starts automatically on notify-send by GDBus)
# - gnome-keyring-daemon
# - playerctld
# - redshift
# - syncthing

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
    "screen-lock.sh"
)

for program in "${programs[@]}"; do
    if command -v "$program" && ! pidof -sx "$(echo "$program" | cut -d' ' -f1)" ; then
        $program &
    fi
done
