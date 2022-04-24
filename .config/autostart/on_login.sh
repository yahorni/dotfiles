#!/bin/bash

# other settings
export ELINKS_CONFDIR="$XDG_CONFIG_HOME/elinks"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/pythonrc.py"
export R_PROFILE_USER="$XDG_CONFIG_HOME/Rprofile"
export SUDO_ASKPASS="$HOME/.local/bin/wm/dmenupass"
export SXHKD_SHELL="/bin/bash"
export TS_SLOTS=3
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"

# update path
export PATH="$PATH:$HOME/.local/bin/wm"

{ pgrep -x mpd || mpd & } &>/dev/null
