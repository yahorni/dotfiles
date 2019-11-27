#!/bin/sh

[[ $- == *i* ]] || exit

stty -ixon

PS1='\[\033[1;34m\][\u@\h \W]\$ \[\033[0m\]'

set -o vi
shopt -s autocd
shopt -s cdspell
shopt -s checkwinsize
shopt -s direxpand
bind TAB:menu-complete

[ -f $HOME/.config/aliases ] && source "$HOME/.config/aliases" 1>/dev/null
