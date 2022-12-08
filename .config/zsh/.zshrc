#!/bin/zsh

# history
export HISTFILE="$XDG_CACHE_HOME/zsh_history"
export HISTIGNORE=' *'
export HISTSIZE=1000000
export HISTFILESIZE=$HISTSIZE
export SAVEHIST=$HISTSIZE

# prompt
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# vi escape key delay
export KEYTIMEOUT=1

# disable Ctrl-s freeze
stty stop undef

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
setopt hist_ignore_space
unsetopt nomatch

# completions
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zmodload zsh/complist
compinit

# use bash git completions instead of zsh
compdef -d git
autoload bashcompinit && bashcompinit
source /usr/share/git/completion/git-completion.bash 2>/dev/null

# key bindings
[ -f "$HOME/.config/zsh/$TERM.tmp" ] && source "$HOME/.config/zsh/$TERM.tmp"

[[ -n $key[Home]   ]] && bindkey -- $key[Home]   beginning-of-line
[[ -n $key[End]    ]] && bindkey -- $key[End]    end-of-line
[[ -n $key[Delete] ]] && bindkey -- $key[Delete] delete-char
[[ -n $key[Up]     ]] && bindkey -- $key[Up]     up-line-or-history
[[ -n $key[Down]   ]] && bindkey -- $key[Down]   down-line-or-history

bindkey '^[[Z' reverse-menu-complete    # shift-tab
bindkey '^?' backward-delete-char       # vi mode backspace fix
bindkey -M vicmd '^[[P' vi-delete-char  # vi mode delete fix

bindkey -M vicmd '^K' history-beginning-search-backward # backward search in vi command mode
bindkey -M viins '^K' history-beginning-search-backward # backward search in vi insert mode
bindkey -M vicmd '^J' history-beginning-search-forward # forward search in vi command mode
bindkey -M viins '^J' history-beginning-search-forward # forward search in vi insert mode

# use vim keys in tab complete menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

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

# autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=1
bindkey '^ ' autosuggest-accept
autosuggest_sh="$XDG_DATA_HOME/zsh/zsh-autosuggestions.zsh"
[ -f "$autosuggest_sh" ] && source "$autosuggest_sh"

# syntax highlight
syntax_highlight_sh="$XDG_DATA_HOME/zsh/fsh/fast-syntax-highlighting.plugin.zsh"
[ -f "$syntax_highlight_sh" ] && source "$syntax_highlight_sh"

# aliases
[ -f "$XDG_CONFIG_HOME/shell/aliases.sh" ] && source "$XDG_CONFIG_HOME/shell/aliases.sh"
bindkey -s '^o' '^ulfcd\r'
# completions
[ -f "$XDG_CONFIG_HOME/shell/completions.zsh" ] && source "$XDG_CONFIG_HOME/shell/completions.zsh"
# extra settings (for temporary purposes)
[ -f "$XDG_CONFIG_HOME/shell/extra.sh" ] && source "$XDG_CONFIG_HOME/shell/extra.sh"
# fzf
[ -f "$XDG_CONFIG_HOME/fzf/fzf.zsh" ] && source "$XDG_CONFIG_HOME/fzf/fzf.zsh"
