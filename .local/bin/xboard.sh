#!/bin/bash

# keyboard settings
# 1. numpad:microsoft           enable microsoft numpad
# 2. grp:caps_toggle            switch language on caps
# 3. grp_led:caps               toggle light on capslock
# 4. terminate:ctrl_alt_bksp    terminate X11 on Ctrl+Alt+Backspace
# 5. lv3:ralt_switch            enable 3rd keyboard level with Right_Alt
# 6. misc:typo                  additional typo symbols
# 7. keypad:pointerkeys         toggle numpad mouse control: Alt+Shift+NumLock
setxkbmap \
    -layout us,ru \
    -option numpad:microsoft,grp:caps_toggle,grp_led:caps,terminate:ctrl_alt_bksp,misc:typo,keypad:pointerkeys,compose:ralt

# keyboard speed
xset r rate 200 35

# xmodmap binds
[ -f "$XDG_CONFIG_HOME/xmodmaprc" ] && xmodmap "$XDG_CONFIG_HOME/xmodmaprc"
