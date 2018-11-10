#!/bin/sh

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

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [[ $(tty) = "/dev/tty1" ]]; then
    pgrep -x i3 || exec startx \
		1>$HOME/Services/xorg.1.log \
		2>$HOME/Services/xorg.2.log
fi

# source ~/.cache/wal/colors-tty.sh
