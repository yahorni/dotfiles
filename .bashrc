#!/bin/bash

[[ $- == *i* ]] || return

# disable Ctrl-R freeze
stty -ixon

# prompt
set_prompt() {
    local blue='\e[34m'
    local green='\e[32m'
    local magenta='\e[35m'
    local red='\e[31m'
    local yellow='\e[33m'

    local bold='\e[1m'
    local default='\e[39;0m'

    # shellcheck disable=SC2155
    local symbol=$([ "$EUID" -eq 0 ] && printf '#' || printf '\$')

    # square brackets -- non-printing escape sequence
    # line overwrite itself when escape sequences not in '[]'
    PS1="\[$bold$red\][\[$yellow\]\u\[$green\]@\[$blue\]\h \[$magenta\]\W\[$red\]]\[$default\]$symbol "
}
set_prompt

# options
set -o vi
shopt -s autocd
shopt -s cdspell
shopt -s checkwinsize
shopt -s direxpand

# bindings
bind TAB:menu-complete
bind 'set show-all-if-ambiguous on'
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear-screen'
bind 'Control-o: "lfcd\n"'

# fzf
[ -f "/usr/share/fzf/completion.bash"   ] && source "/usr/share/fzf/completion.bash"
[ -f "/usr/share/fzf/key-bindings.bash" ] && source "/usr/share/fzf/key-bindings.bash"

# aliases
[ -f "$XDG_CONFIG_HOME/shell/aliases.sh" ] && source "$XDG_CONFIG_HOME/shell/aliases.sh"
# completions
[ -f "$XDG_CONFIG_HOME/shell/completions.bash" ] && source "$XDG_CONFIG_HOME/shell/completions.bash"
# temporary settings
[ -f "$XDG_CONFIG_HOME/shell/temp.sh" ] && source "$XDG_CONFIG_HOME/shell/temp.sh"
