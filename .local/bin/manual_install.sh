#!/bin/bash

set -e

# --- todo ---
# 1. clipboard (greenclip/xclip/xsel)
# 2. ripgrep
# 3. bat
# 4. cmake
# --- dependencies ---
#   yum:    libXft-devel libXtst-devel gtk3-devel
#           automake ncurses-devel bison libevent-devel  (tmux)
#   apt:    libxinerama-dev libx11-xcb-dev libxcb-res0-dev                  (dwm)
#           libcairo2-dev libxcb-image0-dev libxcb-utils-dev libjpeg-dev    (xwallpaper)
#           libtool-bin pkg-config cmake                                    (neovim)
#           xutils-dev      (libxft-bgra)
#           libevent-dev    (tmux)
#           libxtst-dev     (xmouseless)
#   pacman: go-md2man       (brillo)

log2() {
    echo "==> $1" 1>&2
}

cd_or_exit() {
    cd "$1" || { log2 "fail: cd $1" ; exit 1 ;}
}

check_args() {
    [ "$#" -lt 1 ] && log2 "fail: target is needed" && exit 1

    if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
        echo "usage: $(basename "$0") [-h] [-c|--no-cleanup] <target>"
        echo "supported programs:"
        echo "${progs[@]}" "${non_git_progs[@]}" | fmt | column -t
        exit
    fi

    if [ "$1" == "-c" ] || [ "$1" == "--no-cleanup" ]; then
        no_cleanup=1
        shift
    fi

    target="$1"

    # shellcheck disable=SC2076
    if [[ " ${progs[*]} " =~ " $target " ]]; then
        is_git_needed=1
    elif [[ " ${non_git_progs[*]} " =~ " $target " ]]; then
        is_git_needed=0
    else
        log2 "fail: program is not supported" && exit 1
    fi

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
        neovim)     branch="release-0.9" ;;
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

prepare_env_dir() {
    [ ! -d "$env_dir" ] && mkdir -p "$env_dir"
    cd_or_exit "$env_dir"

    if [ -d "$target" ]; then
        cd_or_exit "$target"
        return 1
    fi
}

clone_repo() {
    log2 "clone_repo()"

    if ! prepare_env_dir ; then
        log2 "skip clone_repo()"
        return
    fi

    git clone "$repo" "$target"
    cd_or_exit "$target"
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

prepare_build_dir() {
    log2 "prepare_build_dir()"

    if ! prepare_env_dir ; then
        log2 "skip prepare_build_dir()"
        return
    fi

    mkdir -pv "$target"
    cd_or_exit "$target"

    case "$target" in
        python3.8)
            curl -O https://www.python.org/ftp/python/3.8.12/Python-3.8.12.tgz
            tar xvf Python-3.8.12.tgz
            ;;
        python3.8-pip)
            curl -O https://bootstrap.pypa.io/get-pip.py
            ;;
    esac
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
        python3.8)
            cd_or_exit "Python-3.8.12"
            ./configure --enable-optimizations --enable-shared
            make -j"$(nproc)"
            ;;
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
        python3.8)
            # altinstall - installs to /usr/local
            sudo make altinstall
            sudo ln -s /usr/local/bin/python3.8 /usr/local/bin/python3
            ;;
        python3.8-pip) sudo python3.8 ./get-pip.py ;;
        *) log2 "skip install()" ;;
    esac
}

cleanup() {
    log2 "cleanup()"

    case "$target" in
        st|dmenu|dwm|dwmbar|dragon|xmouseless|htop-vim|xwallpaper|ncmpcpp|neovim)
            make clean
            ;;
        libxft-bgra)
            rm -f "1.patch" ./**/*.rej ./**/*.orig
            git checkout .
            make clean
            ;;
        python3.8)
            sudo make clean
            ;;
        *) log2 "skip cleanup()" ;;
    esac
}

# ===================================== #

progs=(st dmenu dwm dwmbar dotfiles df dragon
       xmouseless term-theme brillo htop-vim sshrc
       fzf ctags zsh-as zsh-fsh xwallpaper acpilight
       libxft-bgra ncmpcpp neovim lf xurls tmux)
non_git_progs=(python3.8 python3.8-pip)
env_dir="$HOME/prog/env"

git_name="NickoEgor"
git_email="egor1998nick@gmail.com"

no_cleanup=0
is_git_needed=

target=
repo=
branch=

# ===================================== #

check_args "$@"

if [ $is_git_needed -eq 1 ]; then
    set_program_params
    clone_repo
    pull_updates
    setup_repo
else
    prepare_build_dir
fi

build
install
[ $no_cleanup == 0 ] && cleanup
