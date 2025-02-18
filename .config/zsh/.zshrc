#!/usr/bin/zsh

# prompt
color=$'\e[32m'
PS1="%B%{$color%}%~$%b "

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
autoload -Uz compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
## dirty hack to disable annoying completion from /etc/hosts:
## https://superuser.com/questions/1098829/stop-zsh-incorporating-etc-hosts-in-autocomplete
zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//,/ }
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'
zmodload zsh/complist
# check cache once a day
# https://gist.github.com/ctechols/ca1035271ad134841284
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

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
bindkey -s '^o' '^ulfcd\r'

bindkey -M vicmd '^K' history-beginning-search-backward # backward search in vi command mode
bindkey -M viins '^K' history-beginning-search-backward # backward search in vi insert mode
bindkey -M vicmd '^J' history-beginning-search-forward # forward search in vi command mode
bindkey -M viins '^J' history-beginning-search-forward # forward search in vi insert mode

# backward incremental search
bindkey -M viins '^R' history-incremental-search-backward

# use vim keys in tab complete menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# cursor
function _set_block_cursor() { echo -ne '\e[2 q' }
function _set_beam_cursor() { echo -ne '\e[6 q' }
function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]] ||
       [[ $1 = 'block' ]]; then
        _set_block_cursor
    elif [[ ${KEYMAP} == main ]] ||
         [[ ${KEYMAP} == viins ]] ||
         [[ ${KEYMAP} = '' ]] ||
         [[ $1 = 'beam' ]]; then
        _set_beam_cursor
  fi
}
zle -N zle-keymap-select
# ensure beam cursor when starting new terminal
precmd_functions+=(_set_beam_cursor)
# ensure insert mode and beam cursor when exiting vim
zle-line-init() { zle -K viins; _set_beam_cursor }

# autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=1
autosuggest="/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
[ -f "$autosuggest" ] && source "$autosuggest"

# syntax highlight
syntax_highlight="/usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
[ -f "$syntax_highlight" ] && source "$syntax_highlight"

# fzf
[ -f "/usr/share/fzf/completion.zsh"   ] && source "/usr/share/fzf/completion.zsh"
[ -f "/usr/share/fzf/key-bindings.zsh" ] && source "/usr/share/fzf/key-bindings.zsh"

# aliases
[ -f "$XDG_CONFIG_HOME/shell/aliases.sh" ] && source "$XDG_CONFIG_HOME/shell/aliases.sh"
# temporary settings
[ -f "$XDG_CONFIG_HOME/shell/temp.sh" ] && source "$XDG_CONFIG_HOME/shell/temp.sh"
