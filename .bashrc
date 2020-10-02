#!/bin/bash

[[ $- == *i* ]] || exit

# disable Ctrl-R freeze
stty -ixon

# colors for prompt
bold='\e[1m'
green='\e[32m'
yellow='\e[33m'
red='\e[31m'
blue='\e[34m'
magenta='\e[35m'
default='\e[39;0m'

# prompt
PS1="\[$bold$red\][\[$yellow\]\u\[$green\]@\[$blue\]\h \[$magenta\]\W\[$red\]]\[$default\]\$ "

# simple prompt
# PS1='\[\033[1;34m\][\u@\h \W]\$ \[\033[0m\]'

# options
set -o vi
shopt -s autocd
shopt -s cdspell
shopt -s checkwinsize
shopt -s direxpand
bind TAB:menu-complete

# aliases
[ -f $HOME/.config/aliases ] && source "$HOME/.config/aliases" 1>/dev/null
