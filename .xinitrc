#!/bin/bash

# settings
xset r rate 200 35              # keyboard speed
xsetroot -cursor_name left_ptr  # default cursor
xset s on                       # enable screensaver
xset s 600                      # seconds before screensave

# xresources
if [ -f "$XDG_CONFIG_HOME/xresources" ]; then
    xrdb -merge "$XDG_CONFIG_HOME/xresources" & xrdbpid=$!
fi

# autostart
if [ -f "$XDG_CONFIG_HOME/shell/on_x11.sh" ]; then
    "$XDG_CONFIG_HOME/shell/on_x11.sh" &
fi

# ensure that xrdb has finished running before starting the WM/DE
[ -n "$xrdbpid" ] && wait "$xrdbpid"

# start wm
[ -n "$WM" ] && exec "$WM"
