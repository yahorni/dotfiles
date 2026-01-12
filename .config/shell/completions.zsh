#!/usr/bin/env zsh

_cdc() { [ -d "${XDG_CONFIG_HOME}" ] && _files -W "${XDG_CONFIG_HOME}" -g '*(/)'; }; compdef _cdc cdc
_cdh() { [ -d "${XDG_CACHE_HOME}"  ] && _files -W "${XDG_CACHE_HOME}"  -g '*(/)'; }; compdef _cdh cdh
_cds() { [ -d "${XDG_DATA_HOME}"   ] && _files -W "${XDG_DATA_HOME}"   -g '*(/)'; }; compdef _cds cds
_cdj() { [ -d "${HOME}/prj"        ] && _files -W "${HOME}/prj"        -g '*(/)'; }; compdef _cdj cdj
