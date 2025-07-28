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

# utilities
alias \
    v='${EDITOR}' \
    V='${EDITOR} --clean' \
    g='git' \
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

# macros
alias \
    dg='/usr/bin/git --git-dir="${HOME}/prj/df" --work-tree="${HOME}"' \
    rst='reset && source ~/.bashrc && stty sane && tput cvvis' \
    mk='DESTDIR= make PREFIX="~/.local"' \
    snc='watch -d grep -e Dirty: -e Writeback: /proc/meminfo'

# files
alias \
    va='${EDITOR} ${XDG_CONFIG_HOME}/shell/aliases.sh' \
    vp='${EDITOR} ${XDG_CONFIG_HOME}/shell/profile.sh' \
    vv='pushd ${XDG_CONFIG_HOME}/nvim ; ${EDITOR} init.* ; popd' \
    vs='${EDITOR} ${XDG_CONFIG_HOME}/sxhkd/sxhkdrc' \
    vf='${EDITOR} ${XDG_CONFIG_HOME}/vifm/vifmrc' \
    vl='${EDITOR} ${XDG_CONFIG_HOME}/lf/lfrc' \
    vz='${EDITOR} ${XDG_CONFIG_HOME}/zsh/.zshrc' \
    vq='${EDITOR} ${XDG_CONFIG_HOME}/qutebrowser/config.py' \
    vm='${EDITOR} ${XDG_CONFIG_HOME}/mimeapps.list' \
    vu='${EDITOR} ${XDG_CONFIG_HOME}/user-dirs.dirs' \
    vt='${EDITOR} ${XDG_CONFIG_HOME}/x11/autostart.sh' \
    vr='${EDITOR} ${XDG_CONFIG_HOME}/x11/xresources' \
    vj='${EDITOR} ${XDG_CONFIG_HOME}/shell/temp.sh' \
    vh='${EDITOR} ${HISTFILE:-$HOME/.bash_history}' \
    vc='${EDITOR} ${HOME}/.ssh/config' \
    vx='${EDITOR} ${HOME}/.xinitrc' \
    vb='${EDITOR} ${HOME}/.bashrc' \
    vw='${EDITOR} "$(xdg-user-dir PROJECTS)/dwm/config.h"' \
    vg='${EDITOR} .gitignore' \
    v_='${EDITOR} $_'


# cd in subdirectories
cd_subdir() {
    cd "$1" || return 1
    [ -n "$2" ] && cd "$2" || return 1
}

# xdg dirs
alias \
    cdx='cd_subdir "$(xdg-user-dir DOCUMENTS)"' \
    cdd='cd_subdir "$(xdg-user-dir DOWNLOAD)"' \
    cdm='cd_subdir "$(xdg-user-dir MUSIC)"' \
    cdp='cd_subdir "$(xdg-user-dir PICTURES)"' \
    cdv='cd_subdir "$(xdg-user-dir VIDEOS)"' \
    cdF='cd_subdir "$(xdg-user-dir VIDEOS)/films"' \
    cdS='cd_subdir "$(xdg-user-dir VIDEOS)/series"' \
    cdy='cd_subdir "$(xdg-user-dir VIDEOS)/downloads"'

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
