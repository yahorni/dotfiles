#!/bin/bash

# nvidia card hacks
if lsmod | grep "nvidia" ; then
    xrandr --setprovideroutputsource modesetting NVIDIA-0
    xrandr --auto

    # configure dpi
    xrandr --dpi 96
fi

# configure monitors
xdisplay.sh

# wallpaper
xwallpaper --stretch "$XDG_DATA_HOME/wallpaper"

# WM bar
dwmbar &
dwmlistener.sh &

# systemd services
#
# systemctl --user enable mpd
# systemctl --user enable mpd-mpris
# systemctl --user enable acpi-volume
#
# 1. transmission
#    https://wiki.archlinux.org/title/Transmission#Choosing_a_user
#    systemctl enable transmission.service
# 2. powertop
#    https://wiki.archlinux.org/title/Powertop#Apply_settings
#    systemctl enable powertop.service
# 3. syncthing
#    systemctl --user enable syncthing.service
# 4. greenclip
#    if fails use: systemctl --user reset-failed greenclip
#    comment "After=display-manager.service" (same for redshift)
#    add "RestartSec=5s" to service to not die too quickly
#    create ~/.config/systemd/user/greenclip.service.d/display.conf and put lines below there:
#        [Service]
#        Environment=DISPLAY=:0
#    systemctl --user enable greenclip.service
# 5. redshift
#    same `display.conf` fix as for greenclip
#    https://wiki.archlinux.org/title/Redshift#Specify_location_manually
#    https://wiki.archlinux.org/title/Redshift#Redshift_works_fine_when_invoked_as_a_command_but_fails_when_run_as_a_systemd_service
#    https://bbs.archlinux.org/viewtopic.php?id=177473
#    systemctl --user enable redshift.service
# 6. playerctl
#    service file taken from: https://wiki.archlinux.org/title/MPRIS#Playerctl
#    ~/.config/systemd/user/playerctld.service
#    added: ExecStop=/usr/bin/pkill -f playerctld
#    same `display.conf` fix as for greenclip
#    systemctl --user enable playerctld.service

# autostart
autostart=(
    "dunst"
    "picom"
    "sxhkd"
    "unclutter"
    "nm-applet"
    "aw-qt"

    "remapd.sh"
    "power-monitor.sh"
    "player-manager.py"
)

for program in "${autostart[@]}"; do
    pidof -sx "$(echo "$program" | cut -d' ' -f1)" || $program &
done >/dev/null 2>&1
