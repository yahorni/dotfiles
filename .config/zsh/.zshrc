#!/bin/zsh

# prompt
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# key bindings
[ -f "$HOME/.zkbd/$TERM.tmp" ] && source  "$HOME/.zkbd/$TERM.tmp"

[[ -n $key[Home]   ]] && bindkey -- $key[Home]   beginning-of-line
[[ -n $key[End]    ]] && bindkey -- $key[End]    end-of-line
[[ -n $key[Delete] ]] && bindkey -- $key[Delete] delete-char
[[ -n $key[Up]     ]] && bindkey -- $key[Up]     up-line-or-history
[[ -n $key[Down]   ]] && bindkey -- $key[Down]   down-line-or-history
bindkey "^?" backward-delete-char # vi mode backspace fix
bindkey '^[[Z' reverse-menu-complete # shift-tab
bindkey -M vicmd 'k' history-beginning-search-backward  # backward search in vi
bindkey -M vicmd 'j' history-beginning-search-forward   # forward search in vi

# vi escape key delay
export KEYTIMEOUT=1

# disable Ctrl-s freeze
stty -ixon

# options
setopt auto_cd
setopt menu_complete
setopt list_packed
setopt mark_dirs
setopt interactive_comments
setopt append_history
setopt correct
setopt rm_star_silent
setopt notify
setopt c_bases
setopt octal_zeroes
setopt vi
setopt globdots
setopt hist_ignore_dups
unsetopt nomatch

# completions
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zmodload zsh/complist
compinit

# cursor
function _set_cursor() {
    if [ -z $TMUX ]; then
      echo -ne $1
    else
      echo -ne "\ePtmux;\e\e$1\e\\"
    fi
}
function _set_block_cursor() { _set_cursor '\e[2 q' }
function _set_beam_cursor() { _set_cursor '\e[6 q' }
function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
        _set_block_cursor
    # elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] ||
       # [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
    else
        _set_beam_cursor
  fi
}
zle -N zle-keymap-select
# ensure beam cursor when starting new terminal
precmd_functions+=(_set_beam_cursor) #
# ensure insert mode and beam cursor when exiting vim
zle-line-init() { zle -K viins; _set_beam_cursor }

# aliases
[ -f $HOME/.config/aliases ] && source "$HOME/.config/aliases" 1>/dev/null

# utils
function scr {
    bindir="$HOME/.local/bin"
    file="$(ls $bindir | fzf)"
    [ ! -z "$file" ] && $EDITOR "$bindir/$file"
}

# syntax highlight
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
