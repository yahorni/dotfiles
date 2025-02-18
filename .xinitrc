#!/bin/bash

# xresources
[ -f "$XDG_CONFIG_HOME/x11/xresources" ] && xrdb -merge "$XDG_CONFIG_HOME/x11/xresources" & xrdbpid=$!

# settings
xsetroot -cursor_name left_ptr  # default cursor
xset s on                       # enable screensaver
xset s 600                      # seconds before screensave

# autostart
[ -f "$XDG_CONFIG_HOME/x11/autostart.sh" ] && source "$XDG_CONFIG_HOME/x11/autostart.sh"

# ensure that xrdb has finished running before starting x11
[ -n "$xrdbpid" ] && wait "$xrdbpid"

# start x11
# shellcheck disable=SC2086
[ -n "$WM" ] && exec $WM $WM_ARGS
