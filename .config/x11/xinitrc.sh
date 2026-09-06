#!/bin/bash

# system X11 configuration (taken from `/etc/X11/xinit/xinitrc`)
if [ -d "/etc/X11/xinit/xinitrc.d" ] ; then
    for xscript in "/etc/X11/xinit/xinitrc.d"/?*.sh ; do
        [ -x "$xscript" ] && source "$xscript"
    done
fi

# xresources
[ -f "$XDG_CONFIG_HOME/x11/xresources" ] && xrdb -merge "$XDG_CONFIG_HOME/x11/xresources"

# x11 settings
xset s on               # screensaver on (default: 10m idle)
xset dpms 600 600 610   # DPMS delay
xset b off              # disable keyboard bell
xsetroot -cursor_name left_ptr  # default cursor

# autostart programs
autostart=(
    # installed
    "nm-applet" "picom" "sxhkd" "unclutter"
    # custom
    "dwmbar" "remapd.sh" "set-wallpaper.sh" "xdisplay.sh"
)
[ "$(hostnamectl chassis)" = "laptop" ] && autostart+=("power-monitor.sh")

for program in "${autostart[@]}"; do
    if command -v "$program" && ! pidof -sx "$(echo "$program" | cut -d' ' -f1)" ; then
        "$program" &
    fi
done

# manual service start (https://github.com/cdown/clipmenu/issues/141)
systemctl --user start clipmenud.service

# start window manager
[ -n "$WM" ] && exec $WM $WM_ARGS
