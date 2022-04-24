#!/bin/bash

set -e

check_args() {
    target="$1"

    [ "$#" -lt 1 ] && echo "target is needed" && exit 1
    # shellcheck disable=SC2076
    [[ ! " ${progs[*]} " =~ " $target " ]] && echo "prog is not allowed" && exit 1
    [ -d "$env_dir/$target" ] && echo "repo already exists" && exit 1

    return 0
}

set_prog_params() {
    # set repo
    case "$target" in
        *)  repo="https://github.com/NickoEgor/$target" ;;
    esac

    # set branch
    case "$target" in
        st)         branch="patched-unstable-config" ;;
        dwm)        branch="config-bar" ;;
        xmouseless) branch="patched" ;;
        *)          branch="master" ;;
    esac
}

set_upstream() {
    case "$target" in
        st)         upstream="https://git.suckless.org/st" ;;
        dmenu)      upstream="https://git.suckless.org/dmenu" ;;
        dwm)        upstream="https://git.suckless.org/dwm" ;;
        dragon)     upstream="https://github.com/mwh/dragon" ;;
        xmouseless) upstream="https://github.com/jbensmann/xmouseless" ;;
        *) echo "skip set_upstream" && return ;;
    esac

    git remote add upstream "$upstream"
}

prepare_repo() {
    [ ! -d "$env_dir" ] && mkdir -p "$env_dir"
    cd "$env_dir" || exit 1

    git clone "$repo" "$target"
    cd "$target" || "$env_dir"

    [[ "$repo" == *"NickoEgor"* ]] && \
        git remote set-url origin "git@github.com:NickoEgor/$target.git"
    set_upstream
    git checkout "$branch"
    git pull
    git submodule update --init --recursive
    git config user.name "$git_name"
    git config user.email "$git_email"
}

build_target() {
    case "$target" in
        st|dmenu|dwm|dwmbar|dragon|xmouseless) make ;;
        *) echo "skip build" ;;
    esac
}

install_target() {
    case "$target" in
        st|dmenu|dwm|dwmbar|dragon|xmouseless) sudo make install ;;
        *) echo "skip install" ;;
    esac
}

# ===================================== #

progs=(st dmenu dwm dwmbar dotfiles df dragon xmouseless term-theme)
env_dir="$HOME/prog/env"

git_name="NickoEgor"
git_email="egor1998nick@gmail.com"

target=
repo=
branch=

# ===================================== #

check_args "$@"
set_prog_params
prepare_repo
build_target
install_target
