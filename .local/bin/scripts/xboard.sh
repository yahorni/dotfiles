#!/bin/bash

# symbols (level 3 included): /usr/share/X11/xkb/symbols/typo
# keychords: /usr/share/X11/xkb/rules/evdev.lst

# keyboard settings
# 1. numpad:microsoft           enable microsoft numpad
# 2. grp:caps_toggle            switch language on caps
# 3. grp_led:caps               toggle light on capslock
# 4. terminate:ctrl_alt_bksp    terminate X11 on Ctrl+Alt+Backspace
# 5. misc:typo                  additional typo symbols
# 6. keypad:pointerkeys         toggle numpad mouse control: Alt+Shift+NumLock
# 7. compose:sclk               enable compose key with ScrollLock
# 8. lv3:ralt_switch            enable 3rd keyboard level with Right_Alt
setxkbmap \
    -layout us,ru \
    -option numpad:microsoft,grp:caps_toggle,grp_led:caps,terminate:ctrl_alt_bksp,misc:typo,keypad:pointerkeys,compose:sclk,lv3:ralt_switch

# keyboard speed
xset r rate 200 35

# xmodmap binds
[ -f "$XDG_CONFIG_HOME/xmodmaprc" ] && xmodmap "$XDG_CONFIG_HOME/xmodmaprc"
