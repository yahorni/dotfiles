#!/bin/sh

# path
export GOPATH="$HOME/prog/go"
export PATH="$PATH:$HOME/.local/bin:$GOPATH/bin"

# programs
export SHELL="/bin/zsh"
export TERMINAL="st"
export EDITOR="nvim"
export VISUAL="$EDITOR"
export BROWSER="firefox"
export READER="zathura"

# directories
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

# files
export HISTFILE="$XDG_DATA_HOME/sh_history"
export MANPATH="$MANPATH:$XDG_DATA_HOME/man"
export INPUTRC="$XDG_CONFIG_HOME/inputrc"
export R_PROFILE_USER="$XDG_CONFIG_HOME/Rprofile"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/pythonrc.py"
export PYLINTHOME="$XDG_CACHE_HOME/pylint"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ELINKS_CONFDIR="$XDG_CONFIG_HOME/elinks"
export SUDO_ASKPASS="$HOME/.local/bin/dmenu_pass"
export LESSHISTFILE="-"
export TERMINFO="$XDG_DATA_HOME/terminfo"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"
export RANDFILE="$XDG_CACHE_HOME/rnd"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"

# history
export HISTSIZE=1000000
export HISTFILESIZE=$HISTSIZE
export HISTIGNORE=' *'
export SAVEHIST=$HISTSIZE

# colors
export GREP_COLOR="1;31"
export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

[[ -f "$HOME/.zshrc" ]] && . "$HOME/.zshrc"

if [[ $(tty) = "/dev/tty1" ]]; then
	pgrep -x bspwm || exec startx 1>/dev/null 2>/dev/null
fi
