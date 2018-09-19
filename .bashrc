#!/bin/sh

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='\[\033[1;34m\][\u@\h \W]\$ \[\033[0m\]'

(cat ~/.cache/wal/sequences &)
source ~/.cache/wal/colors-tty.sh

set -o vi
shopt -s autocd
shopt -s cdspell

alias ls='ls --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias ccat="highlight --out-format=xterm256" 

alias la='ls -a'
alias ll='ls -lsh'
alias lf='ls -lash'

alias v='vim'
alias sv='sudo vim'
alias spi='sudo pacman -Syu'
alias spr='sudo pacman -Rs'
alias rg='ranger'
alias nb='newsboat'
alias nbr='newsboat -r'
alias mkd='mkdir -pv'
alias smkd='sudo mkdir -pv'
alias rst='reset && source $HOME/.bashrc'

alias yt="youtube-dl --add-metadata -ic -o \"$HOME/Media/films/%(title)s.%(ext)s\""
alias yta="youtube-dl --add-metadata -xic -o \"$HOME/Media/music/%(title)s.%(ext)s\""

alias gst='git status'
alias gd='git diff'
alias gds='git diff --staged'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push origin master'
alias gpf='git push -f origin master'
alias gam='git commit --amend'	
alias gl='git log --oneline --graph'
alias gi='vim $HOME/.gitignore'
alias grh='git reset HEAD'
