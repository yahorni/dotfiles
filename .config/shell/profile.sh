#!/bin/sh

# programs
export TERMINAL='st'
export EDITOR='nvim'
export VISUAL="$EDITOR"
export BROWSER='librewolf'
export READER='zathura'
export OPENER='xdg-open'
export PAGER='less'

# XDG directories
## user
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
## system
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_CONFIG_DIRS="/etc/xdg"

# colors
export GREP_COLORS='mt=1;31'
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# shell history
export HISTFILE="$XDG_STATE_HOME/shell_history"
export HISTIGNORE=' *'
export HISTSIZE=1000000
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL="ignoredups"
export SAVEHIST=$HISTSIZE
export HISTORY_IGNORE="(ls|pwd|exit|cd|htop|lfcd|clear)"

# basic settings
export INPUTRC="$XDG_CONFIG_HOME/shell/inputrc"
export LESS='-RMx4'
export LESSHISTFILE='-'
export RANDFILE="$XDG_CACHE_HOME/rnd"
export SYSTEMD_PAGER='less'
export TERMINFO="$XDG_DATA_HOME/terminfo"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export WGETRC="$XDG_CONFIG_HOME/wgetrc"

# apps/dev
export CM_LAUNCHER="rofi"
export ELINKS_CONFDIR="$XDG_CONFIG_HOME/elinks"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export LEDGER="$XDG_DATA_HOME/common.ledger"
export MERGETOOL="$EDITOR -d"
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgreprc"
export SQLITE_HISTORY="$XDG_STATE_HOME/sqlite_history"
export SUDO_ASKPASS="$HOME/.local/bin/scripts/ask-pass.sh"
export SXHKD_SHELL='/bin/bash'
export TS_SLOTS=3
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
## go
export GOPATH="$XDG_DATA_HOME/go"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
export PATH="$PATH:$GOPATH/bin"
## python
export PYTHON_HISTORY="$XDG_STATE_HOME/python_history"
export PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME/python"
export PYTHONUSERBASE="$XDG_DATA_HOME/python"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/pythonrc.py"
export PYLINTHOME="$XDG_CACHE_HOME/pylint"
export PYLINTRC="$XDG_CONFIG_HOME/pylintrc"
export MYPY_CACHE_DIR="$XDG_CACHE_HOME/mypy"
## javascript
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NODE_REPL_HISTORY="$XDG_STATE_HOME/node_repl_history"
export PATH="$PATH:$XDG_DATA_HOME/npm/bin"
## UI
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
export _JAVA_AWT_WM_NONREPARENTING=1    # fix java apps in wm
export QT_SCREEN_SCALE_FACTORS=1.3      # increase UI scale for QT apps

# path
export PATH="$PATH:$(find ~/.local/bin -type d -printf %p:)"

# X11 GUI
if [ -f "$XDG_CONFIG_HOME/x11/xprofile.sh" ]; then
    # profiles stored in $XDG_CONFIG_HOME/x11/xprofiles
    source "$XDG_CONFIG_HOME/x11/xprofile.sh"

    if [ "$USE_XSESSION" = 'false' ] && [ "$(tty)" = '/dev/tty1' ] && [ -n "$WM" ]; then
        local xlog1="$XDG_DATA_HOME/xorg/Xorg.1.log"
        local xlog2="$XDG_DATA_HOME/xorg/Xorg.2.log"

        [ -f "$xlog1" ] && mv "$xlog1" "$xlog1.old"
        [ -f "$xlog2" ] && mv "$xlog2" "$xlog2.log"

        pgrep -x "$WM" || exec startx 1>"$xlog1" 2>"$xlog2"
    fi
fi
