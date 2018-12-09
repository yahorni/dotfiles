#!/bin/bash

export PATH="$PATH:$HOME/.scripts:$HOME/.local/bin"
export EDITOR="vim"
export VISUAL="vim"
export BROWSER="qutebrowser"
export TERMINAL="st"
export READER="zathura"
export SUDO_ASKPASS="$HOME/.scripts/dpass"
export GREP_COLOR="1;31"
export LESSHISTFILE="-"
export HISTFILE="$HOME/Services/bash_history"
export HISTSIZE=
export HISTFILESIZE=
export XDG_CONFIG_HOME="$HOME/.config"

export ANDROID_HOME="/mnt/workext4/AndroidSDK/Sdk"
export ANDROID_SDK_HOME="/mnt/workext4/AndroidSDK/android"
export ANDROID_EMULATOR_HOME="/mnt/workext4/AndroidSDK/android"
export ANDROID_SDK_ROOT="/mnt/workext4/AndroidSDK/android"
export ANDROID_AVD_HOME="/mnt/workext4/AndroidSDK/android/avd"

export MEDIA="$HOME/Media"
export MUSIC="$MEDIA/music"
export FILMS="$MEDIA/films"
export VIDEOS="$MEDIA/videos"
export SERIALS="$MEDIA/serials"
export PODCASTS="$MEDIA/podcasts"
export PICTURES="$MEDIA/pictures"

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [[ $(tty) = "/dev/tty1" ]]; then
    pgrep -x i3 || exec startx \
		1>$HOME/Services/xorg.1.log \
		2>$HOME/Services/xorg.2.log
fi
