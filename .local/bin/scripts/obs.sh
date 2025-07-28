#!/bin/bash

cd "$HOME/dox/notes" || exit 1

# cmd=
# case "$1" in
#     "quick") cmd=':ObsidianQuickSwitch' ;;
#     "today") cmd=':ObsidianToday' ;;
#     "yesterday") cmd=':ObsidianToday -1' ;;
#     "tomorrow") cmd=':ObsidianToday +1' ;;
#     "search") cmd=':ObsidianSearch' ;;
# esac
# exec "$TERMINAL" -e "$EDITOR" -c "$cmd"

file=
case "$1" in
    "today")     file="./10 personal/11 journal/$(date                +"%Y-%m %B/%Y-%m-%d").md" ;;
    "yesterday") file="./10 personal/11 journal/$(date -d "yesterday" +"%Y-%m %B/%Y-%m-%d").md" ;;
    "tomorrow")  file="./10 personal/11 journal/$(date -d "tomorrow"  +"%Y-%m %B/%Y-%m-%d").md" ;;
    "ledger")    file="$(find ./*personal/*finance/*ledger/ -maxdepth 1 -name "$(date +%Y)"'.ledger' | head -n1)" ;;
esac

if [ -z "$file" ]; then
    exec "$TERMINAL" -e "$EDITOR"
else
    exec "$TERMINAL" -e "$EDITOR" "$file"
fi
