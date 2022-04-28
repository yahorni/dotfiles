#!/bin/bash

set -e

# TODO:
# wm-scripts, vifmrun, lf, screenshot (maim), clipboard (greenclip/xclip/xsel/etc)
# libxft-bgra, neovim/vim (appimage), ripgrep, fzf, xwallpaper, mpd/ncmpcpp

# Dependencies:
# yum (centos 7): libXft-devel libXtst-devel gtk3-devel

check_args() {
    target="$1"

    [ "$#" -lt 1 ] && echo "==> target is needed" && exit 1
    # shellcheck disable=SC2076
    [[ ! " ${progs[*]} " =~ " $target " ]] && echo "==> prog is not allowed" && exit 1

    return 0
}

set_prog_params() {
    # set repo
    case "$target" in
        htop-vim)   repo="https://github.com/KoffeinFlummi/htop-vim" ;;
        *)          repo="https://github.com/NickoEgor/$target" ;;
    esac

    # set branch
    case "$target" in
        st)         branch="patched-config" ;;
        dwm)        branch="config-bar" ;;
        xmouseless) branch="patched" ;;
        *)          branch="master" ;;
    esac
}

set_upstream() {
    if git remote -v | grep -qm1 upstream ; then
        echo "==> skip set_upstream()"
        return 0
    fi

    case "$target" in
        st)         upstream="https://git.suckless.org/st" ;;
        dmenu)      upstream="https://git.suckless.org/dmenu" ;;
        dwm)        upstream="https://git.suckless.org/dwm" ;;
        dragon)     upstream="https://github.com/mwh/dragon" ;;
        xmouseless) upstream="https://github.com/jbensmann/xmouseless" ;;
        sshrc)      upstream="https://github.com/cdown/sshrc" ;;
        *) echo "==> skip set_upstream()" && return ;;
    esac

    git remote add upstream "$upstream"
}

clone_repo() {
    [ ! -d "$env_dir" ] && mkdir -p "$env_dir"
    cd "$env_dir" || exit 1

    if [ -d "$target" ]; then
        cd "$target" || exit 1
        echo "==> skip clone_repo()"
        return
    fi

    git clone "$repo" "$target"
    cd "$target" || exit 1

    git pull
    git submodule update --init --recursive

    git checkout "$branch"
}

setup_repo() {
    if [[ "$repo" == *"NickoEgor"* ]]; then
        git remote set-url origin "git@github.com:NickoEgor/$target.git"

        git config user.name "$git_name"
        git config user.email "$git_email"

        set_upstream
    fi
}

build_target() {
    case "$target" in
        st|dmenu|dwm|dwmbar|dragon|xmouseless) make ;;
        htop-vim) ./autogen.sh && ./configure && make ;;
        *) echo "==> skip build_target()" ;;
    esac
}

install_target() {
    case "$target" in
        st|dmenu|dwm|dwmbar|dragon|xmouseless|htop-vim|sshrc) sudo make install ;;
        *) echo "==> skip install_target()" ;;
    esac
}

cleanup() {
    case "$target" in
        st|dmenu|dwm|dwmbar|dragon|xmouseless|htop-vim) make clean ;;
        *) echo "==> skip cleanup()" ;;
    esac
}

# ===================================== #

progs=(st dmenu dwm dwmbar dotfiles df dragon xmouseless term-theme htop-vim sshrc)
env_dir="$HOME/prog/env"

git_name="NickoEgor"
git_email="egor1998nick@gmail.com"

target=
repo=
branch=

# ===================================== #

check_args "$@"
set_prog_params
clone_repo
setup_repo
build_target
install_target
cleanup
