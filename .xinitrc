#!/bin/bash

# keyboard
# 1. numpad:microsoft           enable microsoft numpad
# 2. grp:caps_toggle            switch language on caps
# 3. grp_led:caps               toggle light on capslock
# 4. terminate:ctrl_alt_bksp    terminate X11 on Ctrl+Alt+Backspace
# 5. lv3:ralt_switch            enable 3rd keyboard level with Right_Alt
# 6. misc:typo                  additional typo symbols
# 7. keypad:pointerkeys         toggle numpad mouse control: Alt+Shift+NumLock
setxkbmap \
    -layout us,ru \
    -option numpad:microsoft,grp:caps_toggle,grp_led:caps,terminate:ctrl_alt_bksp,lv3:ralt_switch,misc:typo,keypad:pointerkeys

# xresources
[ -f "$XDG_CONFIG_HOME/xresources" ] && xrdb -merge "$XDG_CONFIG_HOME/xresources" & xrdbpid=$!

# xmodmap binds
[ -f "$XDG_CONFIG_HOME/xmodmaprc" ] && xmodmap "$XDG_CONFIG_HOME/xmodmaprc"

# settings
xsetroot -cursor_name left_ptr  # default cursor
xset s on                       # enable screensaver
xset s 600                      # seconds before screensave
xset r rate 200 35              # keyboard speed

# autostart
[ -f "$XDG_CONFIG_HOME/shell/on_x11.sh" ] && source "$XDG_CONFIG_HOME/shell/on_x11.sh"

# ensure that xrdb has finished running before starting x11
[ -n "$xrdbpid" ] && wait "$xrdbpid"

# start x11
# shellcheck disable=SC2086
[ -n "$WM" ] && exec $WM $WM_ARGS
