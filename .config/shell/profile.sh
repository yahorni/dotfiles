#!/bin/sh

# programs
export SHELL='/bin/zsh'
export TERMINAL='st'
export EDITOR='nvim'
export VISUAL="$EDITOR"
export BROWSER='firefox'
export READER='zathura'
export OPENER='xdg-open'
export PAGER='less'

# XDG directories
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

# colors
export GREP_COLORS='mt=1;31'
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# settings
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export GOPATH="$HOME/prog/go"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
export INPUTRC="$XDG_CONFIG_HOME/shell/inputrc"
export LESS='-RMx4'
export LESSHISTFILE='-'
export MANPATH="$MANPATH:$XDG_DATA_HOME/man:$XDG_CACHE_HOME/cppman/cppreference.com"
export MERGETOOL='nvim -d'
export PYLINTHOME="$XDG_CACHE_HOME/pylint"
export PYLINTRC="$XDG_CONFIG_HOME/pylintrc"
export RANDFILE="$XDG_CACHE_HOME/rnd"
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgreprc"
export SSHHOME="$XDG_CONFIG_HOME/sshrc"
export SYSTEMD_PAGER='less'
export TERMINFO="$XDG_DATA_HOME/terminfo"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"
export VIMINIT="source $XDG_CONFIG_HOME/nvim/init.vim"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export _JAVA_AWT_WM_NONREPARENTING=1    # fix java apps in wm

# path
# shellcheck disable=SC2155
export PATH="$PATH:$(find ~/.local/bin -type d -printf %p:):$GOPATH/bin"

# hidden directory for project files
export IDE_DIR='.ide'

# machine-specific script
[ -f "$XDG_CONFIG_HOME/shell/on_login.sh" ] && source "$XDG_CONFIG_HOME/shell/on_login.sh"

# ssh/tmux login
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] || [ -n "$TMUX" ]; then
    source "$HOME/.bashrc"
fi

# X11 GUI
if [ -f "$XDG_CONFIG_HOME/shell/xprofile.sh" ]; then
    # profiles stored in $XDG_CONFIG_HOME/shell/xprofiles
    source "$XDG_CONFIG_HOME/shell/xprofile.sh"

    if [ "$USE_XSESSION" = 'false' ] && [ "$(tty)" = '/dev/tty1' ] && [ -n "$WM" ]; then
        pgrep -x "$WM" || exec startx \
            1>"$XDG_CACHE_HOME/Xorg.1.log" \
            2>"$XDG_CACHE_HOME/Xorg.2.log"
    fi
fi
