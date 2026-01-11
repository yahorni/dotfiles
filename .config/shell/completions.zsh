#!/usr/bin/env zsh

_cdj() { [[ ! -d "$HOME/prj" ]] && return 1 ;  _files -W "$HOME/prj" -g '*(/)' ; }
compdef _cdj cdj
