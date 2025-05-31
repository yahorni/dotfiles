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

# system progs
alias \
    v='${EDITOR}' \
    vc='${EDITOR} --clean' \
    sv='sudoedit' \
    sc='systemctl' \
    scu='systemctl --user' \
    ssc='sudo systemctl' \
    p3='python3' \
    cp='cp -ri' \
    mime='file --mime-type' \
    tmux='tmux -2' \
    mk='DESTDIR= make PREFIX="~/.local"'

# other progs
alias \
    dg='/usr/bin/git --git-dir="${HOME}/prj/df" --work-tree="${HOME}"' \
    sp='sudo pacman' \
    yay='yay --sudoloop' \
    sa='sudo apt-get' \
    ff='ffplay -autoexit -nodisp' \
    rst='reset && source ~/.bashrc && stty sane && tput cvvis' \
    xo='xdg-open' \
    shr='sshrc' \
    ide='make -f ${IDE_DIR}/Makefile' \
    ides='sudo make -f ${IDE_DIR}/Makefile'

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
    vh='${EDITOR} ${HISTFILE}' \
    vb='${EDITOR} ~/.bashrc' \
    vx='${EDITOR} ~/.xinitrc' \
    vg='${EDITOR} .gitignore' \
    vw='${EDITOR} ~/prj/dwm/config.h' \
    vo='${EDITOR} -c :ObsidianQuickSwitch' \
    v_='${EDITOR} $_'

# directories

cd_subdir() {
    cd "$1" || return 1
    [ -n "$2" ] && cd "$2" || return 1
}

## xdg dirs
alias \
    cdx='cd_subdir "$(xdg-user-dir DOCUMENTS)"' \
    cdd='cd_subdir "$(xdg-user-dir DOWNLOAD)"' \
    cdm='cd_subdir "$(xdg-user-dir MUSIC)"' \
    cdp='cd_subdir "$(xdg-user-dir PICTURES)"' \
    cdv='cd_subdir "$(xdg-user-dir VIDEOS)"' \
    cdF='cd_subdir "$(xdg-user-dir VIDEOS)/films"' \
    cdS='cd_subdir "$(xdg-user-dir VIDEOS)/series"' \
    cdy='cd_subdir "$(xdg-user-dir VIDEOS)/downloads"'

## important dirs
alias \
    cdc='cd_subdir ${XDG_CONFIG_HOME}' \
    cdC='cd_subdir ${XDG_CACHE_HOME}' \
    cds='cd_subdir ${XDG_DATA_HOME}' \
    cdb='cd_subdir ~/.local/bin' \
    cdj='cd_subdir "$(xdg-user-dir PROJECTS)"' \
    cdo='cd "$(xdg-user-dir DOCUMENTS)"/notes/' \
    cdn='cd ${XDG_CONFIG_HOME}/nvim' \
    cd_='cd $_'

## mounts
alias \
    cdP='cd /mnt/phone' \
    cd1='cd /mnt/usb1' \
    cd2='cd /mnt/usb2' \
    cd3='cd /mnt/usb3'

# utils

alias \
    .1='cd ..' \
    .2='cd ../..' \
    .3='cd ../../..' \
    .4='cd ../../../..'

scr() {
    bindir="$HOME/.local/bin/scripts"
    file="$(cd "$bindir" || return 1 ; find . -type f | fzf)"
    [ -n "$file" ] && $EDITOR "$bindir/$file"
}

snc() {
    watch -d grep -e Dirty: -e Writeback: /proc/meminfo
}

lfcd () {
    tmp="$(mktemp -uq)"
    trap 'rm -f $tmp >/dev/null 2>&1 && trap - HUP INT QUIT TERM PWR EXIT' HUP INT QUIT TERM PWR EXIT
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir" || return 1
    fi
}
