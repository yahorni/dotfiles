#!/bin/bash

# completions for aliases
source /usr/share/bash-completion/bash_completion
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

# bare repo alias
__git_complete dg __git_main

# pacman
if command -v pacman 1>/dev/null ; then
  source ${completions}/pacman
  complete -F _pacman pacman sp
fi

# sshrc
if command -v sshrc 1>/dev/null ; then
  source ${completions}/ssh
  complete -F _ssh ssh sshrc shr
fi

# ide
source ${completions}/make
make_completion_wrapper() {
    local function_name="$2"
    local arg_count=$(($#-3))
    local comp_function_name="$1"
    shift 2
    local function="
  $function_name() {
    ((COMP_CWORD+=$arg_count))
    COMP_WORDS=( "$@" \${COMP_WORDS[@]:1} )
    COMP_LINE=\"\${COMP_WORDS[*]}\"
    COMP_POINT=\"\${#COMP_LINE}\"
    "$comp_function_name" "$1"
    return 0
}"
    eval "$function"
}
make_completion_wrapper _make _make_f make -f "${IDE_DIR}/Makefile"
complete -F _make_f ide ides

# cdj
_cdj() { COMPREPLY=($(cd "$HOME/prog" || return 1 ; compgen -d "$2")) ; }
complete -F _cdj cdj
