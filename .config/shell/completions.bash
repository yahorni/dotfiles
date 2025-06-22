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
__git_complete gd _git_diff
__git_complete ga _git_add
__git_complete gb _git_branch
__git_complete gc _git_commit
__git_complete gr _git_remote
__git_complete gm _git_merge
__git_complete gst _git_status
__git_complete gch _git_checkout
__git_complete gps _git_push
__git_complete gpl _git_pull
__git_complete grs _git_reset
__git_complete grb _git_rebase
__git_complete gsh _git_stash
__git_complete gcp _git_cherry_pick
__git_complete gsb _git_submodule

# cdj
_cdj() { COMPREPLY=($(cd "$HOME/prj" || return 1 ; compgen -d "$2")) ; }
complete -F _cdj cdj

# bare repo alias
__git_complete dg __git_main

# pacman
if command -v pacman 1>/dev/null ; then
  source ${completions}/pacman
  complete -F _pacman pacman sp
fi
