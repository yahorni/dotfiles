j!/bin/bash

systemctl --user import-environment DISPLAY XAUTHORITY

# current systemd user services:
# - clipmenud
# - dunst (can't be enabled, starts automatically on notify-send by GDBus)
# - gnome-keyring-daemon
# - playerctld
# - redshift
# - syncthing

programs=(
    # installed
    "nm-applet"
    "picom"
    "sxhkd"
    "unclutter"

    # custom
    "dwmbar"
    "remapd.sh"
    "set-wallpaper.sh"
    "xdisplay.sh"
)

# laptop-only autostart
if [ "$(hostnamectl chassis)" = "laptop" ]; then
    programs+=(
        "screen-lock.sh"
        "power-monitor.sh"
    )
fi

for program in "${programs[@]}"; do
    if command -v "$program" && ! pidof -sx "$(echo "$program" | cut -d' ' -f1)" ; then
        $program &
    fi
done
