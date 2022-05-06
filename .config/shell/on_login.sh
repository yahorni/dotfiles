#!/bin/sh

# other settings
export ELINKS_CONFDIR="$XDG_CONFIG_HOME/elinks"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/pythonrc.py"
export R_PROFILE_USER="$XDG_CONFIG_HOME/Rprofile"
export SUDO_ASKPASS="$HOME/.local/bin/wm/dmenu_pass"
export SXHKD_SHELL='/bin/bash'
export TS_SLOTS=3
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"

[ -f "$XDG_CONFIG_HOME/lf/icons.sh" ] && source "$XDG_CONFIG_HOME/lf/icons.sh"

{ pgrep -x mpd || mpd & } >/dev/null 2>&1
{ pgrep -x acpi_volume.sh || acpi_volume.sh & } >/dev/null 2>&1
