#!/bin/sh

export PATH="$PATH:$HOME/.scripts:$HOME/.bin"
export EDITOR="vim"
export BROWSER="qutebrowser"
export TERMINAL="termite"
export READER="zathura"
export SUDO_ASKPASS="$HOME/.scripts/dpass"
export GREP_COLOR="1;31"
export LESSHISTFILE="-"
export HISTFILE="$HOME/Services/bash_history"
export XDG_CONFIG_HOME="$HOME/.config"

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
	exec startx
fi
