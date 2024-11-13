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
if [ "$WM_BAR" = "dwmbar" ]; then
    dwmbar &
    dwmlistener.sh &
elif [ "$WM_BAR" = "polybar" ]; then
    sleep 10 && exec polybar -r notebar &
fi

# Some services
# /usr/lib/systemd/user/
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
#    same fix as for redshift
#    https://wiki.archlinux.org/title/Redshift#Specify_location_manually
#    https://wiki.archlinux.org/title/Redshift#Redshift_works_fine_when_invoked_as_a_command_but_fails_when_run_as_a_systemd_service
#    https://bbs.archlinux.org/viewtopic.php?id=177473
#    systemctl --user enable redshift.service

# autostart
autostart=(
    "dunst"
    "picom"
    "sxhkd"
    "unclutter"
    "power-monitor.sh"
    "nm-applet"
    "remapd.sh"
    "aw-qt"
)

for program in "${autostart[@]}"; do
    pidof -sx "$(echo "$program" | cut -d' ' -f1)" || $program &
done >/dev/null 2>&1
