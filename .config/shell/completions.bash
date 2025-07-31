#!/bin/bash

# completions for aliases
[ -f "/usr/share/bash-completion/bash_completion" ] &&\
    source "/usr/share/bash-completion/bash_completion"

completions="/usr/share/bash-completion/completions"

# systemctl
source ${completions}/systemctl
complete -F _systemctl systemctl sc ssc scu

# git
source ${completions}/git
__git_complete g __git_main
# bare repo alias
__git_complete dg __git_main

# cdj
_cdj() { COMPREPLY=($(cd "$HOME/prj" || return 1 ; compgen -d "$2")) ; }
complete -F _cdj cdj

# pacman
if command -v pacman 1>/dev/null ; then
    source ${completions}/pacman
    complete -F _pacman pacman sp
fi

# apt-get
if command -v apt-get 1>/dev/null ; then
    source ${completions}/apt-get
    complete -F _apt_get sa
fi
