#!/bin/bash

# path
export GOPATH="/mnt/work/go"
export PATH="$PATH:$HOME/.local/bin:$HOME/.local/scripts:$GOPATH/bin"

# programs
export EDITOR="nvim"
export VISUAL="$EDITOR"
export BROWSER="firefox"
export TERMINAL="st"
export READER="zathura"

# directories
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

# files
export HISTFILE="$XDG_DATA_HOME/bash_history"
export SUDO_ASKPASS="$HOME/.local/scripts/dmenu_pass"
export LESSHISTFILE="-"
export INPUTRC="$HOME/.config/inputrc"
export PYTHONSTARTUP="$HOME/.config/pythonrc"
export MANPATH="$MANPATH:$HOME/.local/share/man"
export R_PROFILE_USER="$HOME/.config/Rprofile"
export GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc-2.0"

# history
export HISTSIZE=
export HISTFILESIZE=
export HISTIGNORE=' *'

# colors
export GREP_COLOR="1;31"
export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# custom
export MEDIA="$HOME/Media"
export MUSIC="$MEDIA/music"
export FILMS="$MEDIA/films"
export VIDEOS="$MEDIA/videos"
export SERIALS="$MEDIA/serials"
export PICTURES="$MEDIA/pictures"
export SCREENSHOTS="$PICTURES/screenshots"
export WALLPAPERS="$PICTURES/wallpapers"

[[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"

if [[ $(tty) = "/dev/tty1" ]]; then
	pgrep -x i3 || exec startx 1>/dev/null 2>/dev/null
fi
