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

alias ls='ls --color=auto --group-directories-first'
alias grep='grep --color=auto'

alias la='ls -a'
alias ll='ls -lsh'
alias l='ls -lash'

alias v='$EDITOR'
alias sv='sudo $EDITOR'
alias sp='sudo pacman'
alias sc='systemctl'
alias ssc='sudo systemctl'
alias fm='vifmrun'
alias nb='newsboat -q'
alias nbr='newsboat -qr'
alias yt='youtube-viewer'
alias cl='calcurse'
alias mkd='mkdir -pv'
alias smkd='sudo mkdir -pv'
alias rst='reset && source ~/.bashrc && stty echo && tput cvvis'
alias cp='cp -r'
alias rm='rm -r'
alias sql='sqlite3'
alias p3='python3'
alias ff='ffplay -autoexit -nodisp'
alias shr='cd $XDG_DATA_HOME'
alias scm='sc-im'

alias dotgit='/usr/bin/git --git-dir="$HOME/Documents/dotfiles" --work-tree="$HOME"'

alias gst='git status'
alias gd='git diff'
alias gds='git diff --staged'
alias ga='git add'
alias gc='git commit'
alias gps='git push'
alias gpl='git pull'
alias gl='git log --oneline --graph --branches'
alias grh='git reset HEAD'
alias gb='git branch'
alias gch='git checkout'
alias gr='git remote'

alias vb='$EDITOR ~/.bashrc'
alias vv='$EDITOR ~/.vimrc'
alias vp='$EDITOR ~/.profile'
alias vg='$EDITOR .gitignore'
alias v3='$EDITOR ~/.config/i3/config'
alias vf='$EDITOR ~/.config/vifm/vifmrc'

completions="/usr/share/bash-completion/completions/"
. $completions/systemctl
complete -F _systemctl systemctl sc ssc
. $completions/pacman
complete -F _pacman pacman sp

alias med='cd ~/Media/ && ls'
alias wrk='cd ~/Work/ && ls'
alias gop='cd $GOPATH/src/ && ls'
alias ltx='cd ~/Work/latex/ && ls'
