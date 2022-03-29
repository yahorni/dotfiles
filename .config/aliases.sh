#!/bin/sh

# colors
alias \
    ls='ls --color=auto --group-directories-first' \
    grep='grep --color=auto'

# fast ls
alias \
    la='ls -A' \
    ll='ls -lsh' \
    l='ls -lAsh'

# progs
alias \
    v='${EDITOR}' \
    sv='sudo ${EDITOR}' \
    sp='sudo pacman' \
    sc='systemctl' \
    scu='systemctl --user' \
    ssc='sudo systemctl' \
    fm='vifmrun' \
    mkd='mkdir -pv' \
    smkd='sudo mkdir -pv' \
    rst='reset && source ~/.bashrc && stty sane && tput cvvis' \
    cp='cp -ri' \
    p3='python3' \
    ff='ffplay -autoexit -nodisp' \
    xo='xdg-open' \
    mim='file --mime-type' \
    shr='sshrc' \
    ide="make -f .nvim/Makefile"

# git
alias \
    dg='/usr/bin/git --git-dir="${HOME}/prog/df" --work-tree="${HOME}"' \
    gst='git status' \
    gd='git diff' \
    gds='git diff --staged' \
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
    grb='git rebase'

# files
alias \
    va='${EDITOR} ${XDG_CONFIG_HOME}/aliases.sh' \
    vv='${EDITOR} ${XDG_CONFIG_HOME}/nvim/init.vim' \
    vs='${EDITOR} ${XDG_CONFIG_HOME}/sxhkd/sxhkdrc' \
    vf='${EDITOR} ${XDG_CONFIG_HOME}/vifm/vifmrc' \
    vz='${EDITOR} ${XDG_CONFIG_HOME}/zsh/.zshrc' \
    vq='${EDITOR} ${XDG_CONFIG_HOME}/qutebrowser/config.py' \
    vb='${EDITOR} ~/.bashrc' \
    vp='${EDITOR} ~/.profile' \
    vx='${EDITOR} ~/.xinitrc' \
    vh='${EDITOR} ${HISTFILE}' \
    vr='${EDITOR} ${XDG_CONFIG_HOME}/Xresources' \
    vg='${EDITOR} .gitignore' \
    vt='${EDITOR} TODO' \
    vw='${EDITOR} ~/prog/env/dwm/config.h'

# directories
alias \
    cdb='cd ~/.local/bin' \
    cds='cd ${XDG_DATA_HOME}' \
    cdc='cd ${XDG_CONFIG_HOME}'
alias \
    cdB='cd "$(xdg-user-dir BOOKS)"' \
    cdx='cd "$(xdg-user-dir DOCUMENTS)"' \
    cdd='cd "$(xdg-user-dir DOWNLOAD)"' \
    cdm='cd "$(xdg-user-dir MUSIC)"' \
    cdp='cd "$(xdg-user-dir PICTURES)"' \
    cdS='cd "$(xdg-user-dir SERIALS)"' \
    cdv='cd "$(xdg-user-dir VIDEOS)"'
alias \
    cdP='cd /mnt/phone' \
    cd1='cd /mnt/usb1' \
    cd2='cd /mnt/usb2' \
    cd3='cd /mnt/usb3' \
    cdo='cd /mnt/other'
alias \
    .1='cd ..' \
    .2='cd ../..' \
    .3='cd ../../..' \

# utils
cdj() {
  cd "$HOME/prog"
  [ -n "$1" ] && cd "$1"
}

scr() {
    bindir="$HOME/.local/bin"
    file="$(ls $bindir | fzf)"
    [ ! -z "$file" ] && $EDITOR "$bindir/$file"
}

snc() {
    watch -d grep -e Dirty: -e Writeback: /proc/meminfo
}

sf() {
    du -a . | cut -f2 | grep "$1"
}

# completion
if [ -n "${BASH}" ]; then
    source /usr/share/bash-completion/bash_completion
    completions="/usr/share/bash-completion/completions"
    # systemctl
    source ${completions}/systemctl
    complete -F _systemctl systemctl sc ssc
    # git
    source ${completions}/git
    __git_complete gd _git_diff
    __git_complete ga _git_add
    __git_complete gb _git_branch
    __git_complete gc _git_commit
    __git_complete gr _git_remote
    __git_complete gst _git_status
    __git_complete gch _git_checkout
    __git_complete gps _git_push
    __git_complete gpl _git_pull
    __git_complete grs _git_reset
    __git_complete grb _git_rebase
    __git_complete gsh _git_stash
    __git_complete gcp _git_cherry_pick
    # bare repo alias
    __git_complete dg git
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
    make-completion-wrapper() {
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
        "$comp_function_name"
        return 0
    }"
        eval "$function"
    }
    make-completion-wrapper _make _make_f make -f .nvim/Makefile
    complete -F _make_f ide
    # cdj
    _cdj() { COMPREPLY=($(cd $HOME/prog ; compgen -d "$2")) ; }
    complete -F _cdj cdj
fi
