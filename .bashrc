#!/bin/sh

stty -ixon

PS1='\[\033[1;34m\][\u@\h \W]\$ \[\033[0m\]'

[[ "$TERM" = *termite* ]] && (cat ~/.cache/wal/sequences &)

set -o vi
shopt -s autocd
shopt -s cdspell

alias ls='ls --color=auto --group-directories-first'
alias grep='grep --color=auto'

alias la='ls -a'
alias ll='ls -lsh'
alias lf='ls -lash'

alias v='vim'
alias sv='sudo vim'
alias sp='sudo pacman'
alias sc='systemctl'
alias ssc='sudo systemctl'
alias rg='ranger'
alias nb='newsboat -q'
alias nbr='newsboat -qr'
alias yt='youtube-viewer'
alias cl='calcurse'
alias mkd='mkdir -pv'
alias smkd='sudo mkdir -pv'
alias rst='reset && source ~/.bashrc'
alias cp='cp -r'
alias rm='rm -r'

completions="/usr/share/bash-completion/completions/" 
. $completions/systemctl
complete -F _systemctl systemctl sc ssc
. $completions/pacman
complete -F _pacman pacman sp

alias gst='git status'
alias gd='git diff'
alias gds='git diff --staged'
alias ga='git add'
alias gc='git commit'
alias gp='git push origin master'
alias gpf='git push -f origin master'
alias gam='git commit --amend'	
alias gl='git log --oneline --graph'
alias gi='vim ~/.gitignore'
alias grh='git reset HEAD'

alias xclip='xclip -selection clipboard'
alias we='cd ~/WorkExt4/ && ls'
alias wn='cd ~/WorkNtfs/ && ls'
alias med='cd ~/Media/ && ls'
alias vb='vim ~/.bashrc'
alias vv='vim ~/.vimrc'
