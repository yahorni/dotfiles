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
    sv='sudoedit' \
    sc='systemctl' \
    scu='systemctl --user' \
    ssc='sudo systemctl' \
    p3='python3' \
    cp='cp -ri' \
    mim='file --mime-type'

# other progs
alias \
    dg='/usr/bin/git --git-dir="${HOME}/prog/df" --work-tree="${HOME}"' \
    sp='sudo pacman' \
    fm='FM=vifm fmrun.sh' \
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
    grp='git remote prune'

# files
alias \
    va='${EDITOR} ${XDG_CONFIG_HOME}/shell/aliases.sh' \
    vv='${EDITOR} ${XDG_CONFIG_HOME}/nvim/init.vim' \
    vs='${EDITOR} ${XDG_CONFIG_HOME}/sxhkd/sxhkdrc' \
    vf='${EDITOR} ${XDG_CONFIG_HOME}/vifm/vifmrc' \
    vl='${EDITOR} ${XDG_CONFIG_HOME}/lf/lfrc' \
    vz='${EDITOR} ${XDG_CONFIG_HOME}/zsh/.zshrc' \
    vq='${EDITOR} ${XDG_CONFIG_HOME}/qutebrowser/config.py' \
    vp='${EDITOR} ${XDG_CONFIG_HOME}/shell/profile' \
    ve='${EDITOR} ${XDG_CONFIG_HOME}/shell/extra.sh' \
    vr='${EDITOR} ${XDG_CONFIG_HOME}/xresources' \
    vb='${EDITOR} ~/.bashrc' \
    vx='${EDITOR} ~/.xinitrc' \
    vh='${EDITOR} ${HISTFILE}' \
    vg='${EDITOR} .gitignore' \
    vt='${EDITOR} $(xdg-user-dir DOCUMENTS)/TODO.md' \
    vw='${EDITOR} ~/prog/env/dwm/config.h' \
    v_='${EDITOR} $_'

# directories
alias \
    cdb='cd ~/.local/bin' \
    cds='cd ${XDG_DATA_HOME}' \
    cdc='cd ${XDG_CONFIG_HOME}' \
    cd_='cd $_'
alias \
    cdB='cd "$(xdg-user-dir BOOKS)"' \
    cdx='cd "$(xdg-user-dir DOCUMENTS)"' \
    cdd='cd "$(xdg-user-dir DOWNLOAD)"' \
    cdm='cd "$(xdg-user-dir MUSIC)"' \
    cdp='cd "$(xdg-user-dir PICTURES)"' \
    cdS='cd "$(xdg-user-dir SERIES)"' \
    cdv='cd "$(xdg-user-dir VIDEOS)"'
alias \
    cdP='cd /mnt/phone' \
    cd1='cd /mnt/usb1' \
    cd2='cd /mnt/usb2' \
    cd3='cd /mnt/usb3' \
    cdo='cd /mnt/other'
alias \
    .2='cd ../..' \
    .3='cd ../../..' \
    .4='cd ../../../..'

# utils
cdj() {
  cd "$HOME/prog" || return 1
  [ -n "$1" ] && cd "$1" || return 1
}

scr() {
    bindir="$HOME/.local/bin"
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
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir" || exit 1
    fi
}
