#!/bin/sh

# programs
export SHELL='/usr/bin/zsh'
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
export XDG_STATE_HOME="$HOME/.local/state"

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
export HISTFILE="$XDG_CACHE_HOME/shell_history"
export HISTIGNORE=' *'
export HISTSIZE=1000000
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL="ignoredups"
export SAVEHIST=$HISTSIZE
export HISTORY_IGNORE="(ls|pwd|exit|cd)"

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
export ELINKS_CONFDIR="$XDG_CONFIG_HOME/elinks"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export LEDGER="$XDG_DATA_HOME/common.ledger"
export MERGETOOL='nvim -d'
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgreprc"
export SQLITE_HISTORY="$XDG_DATA_HOME/sqlite_history"
export SUDO_ASKPASS="$HOME/.local/bin/scripts/dmenu-pass.sh"
export SXHKD_SHELL='/bin/bash'
export TS_SLOTS=3
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
## go
export GOPATH="$HOME/prj/go"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
export PATH="$PATH:$GOPATH/bin"
## python
export PYLINTHOME="$XDG_CACHE_HOME/pylint"
export PYLINTRC="$XDG_CONFIG_HOME/pylintrc"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/pythonrc.py"
export MYPY_CACHE_DIR="$XDG_CACHE_HOME/mypy"
## javascript
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export PATH="$PATH:$XDG_DATA_HOME/npm/bin"
## UI
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
export _JAVA_AWT_WM_NONREPARENTING=1    # fix java apps in wm
export QT_SCREEN_SCALE_FACTORS=1.3      # increase UI scale for QT apps

# path
PATH="$PATH:$(find ~/.local/bin -type d -printf %p:)"
export PATH

# ssh/tmux login
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] || [ -n "$TMUX" ]; then
    [ -f "$HOME/.bashrc" ] && source "$HOME/.bashrc"
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
