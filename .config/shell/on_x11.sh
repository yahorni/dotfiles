#!/bin/bash

# nvidia card hacks
nvidia_lock="$XDG_DATA_HOME/nvidia_lock"
if [ -f "$nvidia_lock" ]; then
    echo "NVIDIA lock detected"
    xrandr --setprovideroutputsource modesetting NVIDIA-0
    xrandr --auto
fi

# wallpaper
xwallpaper --stretch "$XDG_DATA_HOME/wallpaper"

# WM bar
if [ "$WMBAR" = "dwmbar" ]; then
    dwmbar &
    dwmlistener.sh &
elif [ "$WMBAR" = "polybar" ]; then
    sleep 10 && exec polybar -r notebar &
fi

# keyboard
setxkbmap -layout us,ru
# 1. numpad:microsoft           enable microsoft numpad
# 2. grp:caps_toggle            switch language on caps
# 3. grp_led:caps               toggle light on capslock
# 4. terminate:ctrl_alt_bksp    terminate X11 on Ctrl+Alt+Backspace
# 5. lv3:ralt_switch            enable 3rd keyboard level with Right_Alt
# 6. misc:typo                  additional typo symbols
# 7. keypad:pointerkeys         toggle numpad mouse control: Alt+Shift+NumLock
setxkbmap -option numpad:microsoft,grp:caps_toggle,grp_led:caps,terminate:ctrl_alt_bksp,lv3:ralt_switch,misc:typo,keypad:pointerkeys

# xmodmap binds
xmodmap "$XDG_CONFIG_HOME/xmodmaprc"

# screenlock
# xss-lock -- physlock -ms &

# autostart
dunst &
picom &
sxhkd &
unclutter &
greenclip daemon &
suspender &
pgrep transmission-da || transmission-daemon &
nm-applet &
# safeeyes &
# redshift &
# blueman-applet &
