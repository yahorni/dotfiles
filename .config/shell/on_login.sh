#!/bin/sh

# other settings
export ELINKS_CONFDIR="$XDG_CONFIG_HOME/elinks"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/pythonrc.py"
export SUDO_ASKPASS="$HOME/.local/bin/wm/dmenu_pass"
export SXHKD_SHELL='/bin/bash'
export TS_SLOTS=3
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
export SQLITE_HISTORY="$XDG_DATA_HOME/sqlite_history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

# Services enabled with systemd
# 1. mpd
# 2. mpd-mpris
# 3. acpi_volume

{ pidof -sx playerctld || playerctld daemon & } >/dev/null 2>&1
{ pidof -sx player-manager.py || player-manager.py & } >/dev/null 2>&1
