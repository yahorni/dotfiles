#!/bin/bash

set -e

# --- todo ---
# 1. clipboard (greenclip/xclip/xsel)
# 2. ripgrep
# 3. bat
# 4. cmake
#
# --- dependencies ---
#  pkg mgr | target      | deps
#  ---     | ---         | ---
#   apt    | dwm         | libxinerama-dev libx11-xcb-dev libxcb-res0-dev
#          | xwallpaper  | libcairo2-dev libxcb-image0-dev libxcb-utils-dev libjpeg-dev
#          | neovim      | libtool-bin pkg-config cmake
#          | libxft-bgra | xutils-dev
#          | tmux        | libevent-dev
#          | xmouseless  | libxtst-dev
#   yum    | dwm         | libXft-devel libXtst-devel gtk3-devel
#          | tmux        | automake ncurses-devel libevent-devel bison
#          | neovim      | cmake3
#   zypper | tmux        | automake ncurses-devel libevent-devel bison
#   pacman | brillo      | go-md2man

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
        echo "${PROGS_LIST[@]}" "${NON_GIT_PROGS_LIST[@]}" | fmt | column -t
        exit
    fi

    if [ "$1" == "-c" ] || [ "$1" == "--no-cleanup" ]; then
        g_no_cleanup=1
        shift
    fi

    g_target="$1"

    # shellcheck disable=SC2076
    if [[ " ${PROGS_LIST[*]} " =~ " $g_target " ]]; then
        g_is_git_needed=1
    elif [[ " ${NON_GIT_PROGS_LIST[*]} " =~ " $g_target " ]]; then
        g_is_git_needed=0
    else
        log2 "fail: program is not supported" && exit 1
    fi

    return 0
}

set_prog_repo() {
    log2 "set_prog_repo()"

    # set repo
    case "$g_target" in
        htop-vim)   g_repo="https://github.com/KoffeinFlummi/htop-vim.git" ;;
        fzf)        g_repo="https://github.com/junegunn/fzf.git" ;;
        ctags)      g_repo="https://github.com/universal-ctags/ctags.git" ;;
        zsh-as)     g_repo="https://github.com/zsh-users/zsh-autosuggestions.git" ;;
        zsh-fsh)    g_repo="https://github.com/zdharma-continuum/fast-syntax-highlighting" ;;
        xwallpaper) g_repo="https://github.com/stoeckmann/xwallpaper.git" ;;
        acpilight)  g_repo="https://gitlab.com/wavexx/acpilight.git" ;;
        libxft-bgra)g_repo="https://gitlab.freedesktop.org/xorg/lib/libxft.git" ;;
        brillo)     g_repo="https://gitlab.com/cameronnemo/brillo.git" ;;
        ncmpcpp)    g_repo="https://github.com/ncmpcpp/ncmpcpp" ;;
        neovim)     g_repo="https://github.com/neovim/neovim" ;;
        lf)         g_repo="https://github.com/gokcehan/lf" ;;
        xurls)      g_repo="https://github.com/mvdan/xurls" ;;
        tmux)       g_repo="https://github.com/tmux/tmux" ;;
        *)          g_repo="https://github.com/NickoEgor/$g_target.git" ;;
    esac
}

set_prog_branch() {
    log2 "set_prog_branch()"

    # set branch
    case "$g_target" in
        st)         g_branch="patched-config" ;;
        dwm)        g_branch="config-bar" ;;
        xmouseless) g_branch="patched" ;;
        libxft-bgra)g_branch="libXft-2.3.4" ;;      # tag
        neovim)     g_branch="release-0.9" ;;
        tmux)       g_branch="3.3" ;;               # tag
        *)          g_branch="master" ;;
    esac
}

set_upstream() {
    log2 "set_upstream()"

    if git remote -v | grep -qm1 upstream ; then
        log2 "skip set_upstream()"
        return 0
    fi

    case "$g_target" in
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
    [ ! -d "$ENV_DIR" ] && mkdir -p "$ENV_DIR"
    cd_or_exit "$ENV_DIR"

    if [ -d "$g_target" ]; then
        cd_or_exit "$g_target"
        return 1
    fi
}

clone_repo() {
    log2 "clone_repo()"

    if ! prepare_env_dir ; then
        log2 "skip clone_repo()"
        return
    fi

    git clone --depth=1 --branch="$g_branch" "$g_repo" "$g_target"
    cd_or_exit "$g_target"
}

pull_updates() {
    log2 "pull_updates()"

    git pull || :
    git submodule update --init --recursive
}

setup_repo() {
    log2 "setup_repo()"

    local branch
    branch="$(git rev-parse --abbrev-ref HEAD)"
    if [ "$g_branch" != "$branch" ]; then
        git checkout "$g_branch"
    fi

    if [[ "$g_repo" == *"NickoEgor"* ]]; then
        git remote set-url origin "git@github.com:NickoEgor/$g_target.git"

        git config user.name "$GIT_NAME"
        git config user.email "$GIT_EMAIL"

        set_upstream
    fi
}

prepare_build_dir() {
    log2 "prepare_build_dir()"

    if ! prepare_env_dir ; then
        log2 "skip prepare_build_dir()"
        return
    fi

    mkdir -pv "$g_target"
    cd_or_exit "$g_target"

    case "$g_target" in
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

    case "$g_target" in
        st|dmenu|dwm|dwmbar|dragon|xmouseless|brillo) make ;;
        htop-vim|ctags|xwallpaper|tmux) ./autogen.sh && ./configure && make ;;
        libxft-bgra)
            curl "https://gitlab.freedesktop.org/xorg/lib/libxft/-/merge_requests/1.patch" \
                | patch -p1 -N || true
            ./autogen.sh --prefix="/usr/local" --sysconfdir="/etc" --disable-static
            make
            ;;
        ncmpcpp)
            curl "https://gitlab.archlinux.org/archlinux/packaging/packages/ncmpcpp/-/raw/a39bfdeeefc31d6b35fc73f522e53ca74c2fd722/taglib-2.patch" \
                | patch -p1 -N || true
            ./autogen.sh
            BOOST_ROOT=/usr ./configure --enable-visualizer --enable-static-boost
            make -j"$(nproc)"
            ;;
        neovim) make CMAKE_BUILD_TYPE=Release ;;
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

    case "$g_target" in
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

    case "$g_target" in
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

PROGS_LIST=(st dmenu dwm dwmbar dotfiles df dragon
       xmouseless term-theme brillo htop-vim sshrc
       fzf ctags zsh-as zsh-fsh xwallpaper acpilight
       libxft-bgra ncmpcpp neovim lf xurls tmux)
NON_GIT_PROGS_LIST=(python3.8 python3.8-pip)
ENV_DIR="$HOME/prog/env"

GIT_NAME="NickoEgor"
GIT_EMAIL="egor1998nick@gmail.com"

# ===================================== #

g_no_cleanup=0
g_is_git_needed=

g_target=
g_repo=
g_branch=

# ===================================== #

check_args "$@"

if [ $g_is_git_needed -eq 1 ]; then
    set_prog_repo
    set_prog_branch
    clone_repo
    pull_updates
    setup_repo
else
    prepare_build_dir
fi

build
install
[ $g_no_cleanup == 0 ] && cleanup
