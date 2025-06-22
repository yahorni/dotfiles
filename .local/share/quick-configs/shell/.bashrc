#!/bin/bash

[[ $- == *i* ]] || return

## env variables

# programs
export EDITOR=nvim
export VISUAL="$EDITOR"
export PAGER='less'

# XDG directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# colors
export GREP_COLORS='mt=1;31'
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# shell history
export HISTIGNORE=' *'
export HISTSIZE=1000000
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL="ignoredups"
export SAVEHIST=$HISTSIZE
export HISTORY_IGNORE="(ls|pwd|exit|cd|htop|lfcd|clear)"

# basic settings
export LESS="-RMx4"
export LESSHISTFILE="-"
export SYSTEMD_PAGER="less"

# apps/dev
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export MERGETOOL="$EDITOR -d"

# path
export PATH="$PATH:$HOME/.local/bin:/opt/nvim-linux-x86_64/bin:$HOME/Documents/notes/2. areas/scripts"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/lib"

## bashrc options

# disable Ctrl-R freeze
stty -ixon

# prompt
set_prompt() {
    local default='\[\e[39;0m\]'
    local bold='\[\e[1m\]'

    local blue='\[\e[34m\]'
    local magenta='\[\e[35m\]'

    local symbol=$([ "$EUID" -eq 0 ] && printf '#' || printf '$')

    PS1="${bold}${magenta}[\u@\h ${blue}\W${magenta}]${default}${symbol} "
}
set_prompt

# options
set -o vi
shopt -s autocd
shopt -s cdspell
shopt -s checkwinsize
shopt -s direxpand

# disable prompt command
unset PROMPT_COMMAND 2>/dev/null

# bindings
bind TAB:menu-complete
bind 'set show-all-if-ambiguous on'
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear-screen'
bind 'Control-o: "lfcd\n"'

# fzf (apt-get)
[ -f "/usr/share/bash-completion/completions/fzf" ] && source "/usr/share/bash-completion/completions/fzf"
[ -f "/usr/share/doc/fzf/examples/key-bindings.bash" ] && source "/usr/share/doc/fzf/examples/key-bindings.bash"

## aliases

# colors
alias \
    ls='ls --color=auto --group-directories-first' \
    grep='grep --color=auto'

# fast ls
alias \
    la='ls -A' \
    ll='ls -lsh' \
    l='ls -lAsh'

# utilities
alias \
    v='${EDITOR}' \
    V='${EDITOR} --clean' \
    sv='sudoedit' \
    sc='systemctl' \
    scu='systemctl --user' \
    ssc='sudo systemctl' \
    sa='sudo apt-get' \
    sy='sudo yum' \
    sp='sudo pacman' \
    p3='python3' \
    cp='cp -ri' \
    mime='file --mime-type' \
    tmux='tmux -2' \
    ff='ffplay -autoexit -nodisp' \
    xo='xdg-open'

# git
alias \
    gst='git status' \
    gd='git diff' \
    gds='git diff --staged' \
    gdw='git diff --word-diff' \
    ga='git add' \
    gc='git commit' \
    gps='git push' \
    gpl='git pull' \
    gl='git log --oneline --graph --branches' \
    glo='git log --oneline --graph' \
    gb='git branch' \
    gch='git checkout' \
    gr='git remote' \
    gsh='git stash' \
    gcp='git cherry-pick' \
    grs='git reset' \
    gm='git merge' \
    gsb='git submodule' \
    ghist='git log --follow -p --' \
    grb='git rebase' \
    gff='git log --full-history --' \
    gff1='git log --full-history -1 --' \
    gcl='git clean -dfx' \
    grp='git remote prune' \
    ghash='git log -n 1 --pretty=format:"%H"' \
    gsw='git show'

# files
alias \
    vv='pushd ${XDG_CONFIG_HOME}/nvim ; ${EDITOR} init.* ; popd' \
    vl='${EDITOR} ${XDG_CONFIG_HOME}/lf/lfrc' \
    vj='${EDITOR} ${XDG_CONFIG_HOME}/shell/temp.sh' \
    vh='${EDITOR} ${HISTFILE:-$HOME/.bash_history}' \
    vc='${EDITOR} ${HOME}/.ssh/config' \
    vb='${EDITOR} ${HOME}/.bashrc' \
    vo='${EDITOR} -c :ObsidianQuickSwitch' \
    vg='${EDITOR} .gitignore' \
    v_='${EDITOR} $_'

# cd in subdirectories
cd_subdir() {
    cd "$1" || return 1
    [ -n "$2" ] && cd "$2" || return 1
}

# important dirs
alias \
    cdc='cd_subdir ${XDG_CONFIG_HOME}' \
    cdC='cd_subdir ${XDG_CACHE_HOME}' \
    cds='cd_subdir ${XDG_DATA_HOME}' \
    cdb='cd_subdir ${HOME}/.local/bin' \
    cdj='cd_subdir ${HOME}/prj' \
    cdo='cd "$(xdg-user-dir DOCUMENTS)"/notes/' \
    cdn='cd ${XDG_CONFIG_HOME}/nvim' \
    cd_='cd $_'

# mounts
alias \
    cdP='cd /mnt/phone' \
    cd1='cd /mnt/usb1' \
    cd2='cd /mnt/usb2'

# quick cd up
alias \
    .1='cd ..' \
    .2='cd ../..' \
    .3='cd ../../..' \
    .4='cd ../../../..'

# cd to dir with lf
lfcd () {
    tmp="$(mktemp -uq)"
    trap 'rm -f $tmp >/dev/null 2>&1 && trap - HUP INT QUIT TERM PWR EXIT' HUP INT QUIT TERM PWR EXIT
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir" || return 1
    fi
}

# quick open script
scr() {
    bindir="$HOME/.local/bin/scripts"
    file="$(cd "$bindir" || return 1 ; find . -type f | fzf)"
    [ -n "$file" ] && $EDITOR "$bindir/$file"
}

## completions

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

# temporary settings
[ -f "$XDG_CONFIG_HOME/shell/temp.sh" ] && source "$XDG_CONFIG_HOME/shell/temp.sh"
