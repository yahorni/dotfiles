#!/bin/bash

set -e

# --- todo ---
# 1. clipboard (greenclip/xclip/xsel)
# 2. ripgrep
# 3. bat
# --- dependencies ---
#   yum:    libXft-devel libXtst-devel gtk3-devel
#   apt:    libxinerama-dev libx11-xcb-dev libxcb-res0-dev                 (dwm)
#           libcairo2-dev libxcb-image0-dev libxcb-utils-dev libjpeg-dev   (xwallpaper)
#           libtool-bin    (neovim)
#           xutils-dev     (libxft-bgra)
#           livevent-dev   (tmux)
#   pacman: go-md2man   (brillo)

log2() {
    echo "==> $1" 1>&2
}

check_args() {
    target="$1"

    [ "$#" -lt 1 ] && log2 "fail: target is needed" && exit 1
    # shellcheck disable=SC2076
    [[ ! " ${progs[*]} " =~ " $target " ]] && log2 "fail: program is not supported" && exit 1

    return 0
}

set_program_params() {
    log2 "set_program_params()"

    # set repo
    case "$target" in
        htop-vim)   repo="https://github.com/KoffeinFlummi/htop-vim.git" ;;
        fzf)        repo="https://github.com/junegunn/fzf.git" ;;
        ctags)      repo="https://github.com/universal-ctags/ctags.git" ;;
        zsh-as)     repo="https://github.com/zsh-users/zsh-autosuggestions.git" ;;
        zsh-fsh)    repo="https://github.com/zdharma-continuum/fast-syntax-highlighting" ;;
        xwallpaper) repo="https://github.com/stoeckmann/xwallpaper.git" ;;
        acpilight)  repo="https://gitlab.com/wavexx/acpilight.git" ;;
        libxft-bgra)repo="https://gitlab.freedesktop.org/xorg/lib/libxft.git" ;;
        brillo)     repo="https://gitlab.com/cameronnemo/brillo.git" ;;
        ncmpcpp)    repo="https://github.com/ncmpcpp/ncmpcpp" ;;
        neovim)     repo="https://github.com/neovim/neovim" ;;
        lf)         repo="https://github.com/gokcehan/lf" ;;
        xurls)      repo="https://github.com/mvdan/xurls" ;;
        tmux)       repo="https://github.com/tmux/tmux" ;;
        *)          repo="https://github.com/NickoEgor/$target.git" ;;
    esac

    # set branch
    case "$target" in
        st)         branch="patched-config" ;;
        dwm)        branch="config-bar" ;;
        xmouseless) branch="patched" ;;
        libxft-bgra)branch="tags/libXft-2.3.4" ;;
        neovim)     branch="release-0.8" ;;
        tmux)       branch="tags/3.3" ;;
        *)          branch="master" ;;
    esac
}

set_upstream() {
    log2 "set_upstream()"

    if git remote -v | grep -qm1 upstream ; then
        log2 "skip set_upstream()"
        return 0
    fi

    case "$target" in
        st)         upstream="https://git.suckless.org/st" ;;
        dmenu)      upstream="https://git.suckless.org/dmenu" ;;
        dwm)        upstream="https://git.suckless.org/dwm" ;;
        dragon)     upstream="https://github.com/mwh/dragon" ;;
        xmouseless) upstream="https://github.com/jbensmann/xmouseless" ;;
        sshrc)      upstream="https://github.com/cdown/sshrc" ;;
        *)          log2 "skip set_upstream()" && return ;;
    esac

    git remote add upstream "$upstream"
}

clone_repo() {
    log2 "clone_repo()"

    [ ! -d "$env_dir" ] && mkdir -p "$env_dir"
    cd "$env_dir" || { log2 "fail: cd $env_dir" ; exit 1 ;}

    if [ -d "$target" ]; then
        cd "$target" || { log2 "fail: cd $target" ; exit 1 ;}
        log2 "skip clone_repo()"
        return
    fi

    git clone "$repo" "$target"
    cd "$target" || exit 1
}

pull_updates() {
    log2 "pull_updates()"

    git pull || :
    git submodule update --init --recursive
}

setup_repo() {
    git checkout "$branch"

    if [[ "$repo" == *"NickoEgor"* ]]; then
        log2 "setup_repo()"

        git remote set-url origin "git@github.com:NickoEgor/$target.git"

        git config user.name "$git_name"
        git config user.email "$git_email"

        set_upstream
    fi
}

build() {
    log2 "build()"

    case "$target" in
        st|dmenu|dwm|dwmbar|dragon|xmouseless|brillo) make ;;
        htop-vim|ctags|xwallpaper|tmux) ./autogen.sh && ./configure && make ;;
        libxft-bgra)
            curl -O "https://gitlab.freedesktop.org/xorg/lib/libxft/-/merge_requests/1.patch"
            patch -p1 < "1.patch"
            ./autogen.sh --prefix="/usr/local" --sysconfdir="/etc" --disable-static
            make
            ;;
        ncmpcpp)
            ./autogen.sh
            BOOST_ROOT=/usr ./configure --enable-visualizer --enable-static-boost
            make -j"$(nproc)"
            ;;
        neovim) make CMAKE_BUILD_TYPE=RelWithDebInfo ;;
        *) log2 "skip build()" ;;
    esac
}

install() {
    log2 "install()"

    case "$target" in
        st|dmenu|dwm|dwmbar|xmouseless|htop-vim|sshrc|ctags|xwallpaper|acpilight|brillo|ncmpcpp|neovim|tmux)
            sudo make install
            ;;
        dragon) sudo make PREFIX="/usr/local" install ;;
        libxft-bgra) sudo make PREFIX="/usr" install ;;
        fzf) ./install --xdg --key-bindings --no-update-rc --completion ;;
        zsh-as)
            local zsh_data_dir="${XDG_DATA_HOME:-$HOME/.local/share}/zsh"
            mkdir -pv "$zsh_data_dir"
            cp ./zsh-autosuggestions.zsh "$zsh_data_dir/zsh-autosuggestions.zsh"
            ;;
        zsh-fsh)
            local zsh_data_dir="${XDG_DATA_HOME:-$HOME/.local/share}/zsh"
            mkdir -p "$zsh_data_dir"
            ln -s "$PWD" "$zsh_data_dir/fsh"
            ;;
        lf)
            # for go version >= 1.17
            env CGO_ENABLED=0 go install -ldflags="-s -w" github.com/gokcehan/lf@latest
            ;;
        xurls) go install mvdan.cc/xurls/v2/cmd/xurls@latest ;;
        *) log2 "skip install()" ;;
    esac
}

cleanup() {
    log2 "cleanup()"

    case "$target" in
        st|dmenu|dwm|dwmbar|dragon|xmouseless|htop-vim|xwallpaper|ncmpcpp|neovim) make clean ;;
        libxft-bgra)
            rm -f "1.patch" ./**/*.rej ./**/*.orig
            git checkout .
            make clean
            ;;
        *) log2 "skip cleanup()" ;;
    esac
}

# ===================================== #

progs=(st dmenu dwm dwmbar dotfiles df dragon xmouseless term-theme brillo htop-vim sshrc
       fzf ctags zsh-as zsh-fsh xwallpaper acpilight libxft-bgra ncmpcpp neovim lf xurls tmux)
env_dir="$HOME/prog/env"

git_name="NickoEgor"
git_email="egor1998nick@gmail.com"

target=
repo=
branch=

# ===================================== #

check_args "$@"
set_program_params
clone_repo
setup_repo
build
install
cleanup
