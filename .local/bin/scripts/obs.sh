#!/bin/bash
cd "$HOME/dox/notes" || exit 1
cmd=
case "$1" in
    "quick") cmd=':ObsidianQuickSwitch' ;;
    "today") cmd=':ObsidianToday' ;;
    "yesterday") cmd=':ObsidianToday -1' ;;
    "tomorrow") cmd=':ObsidianToday +1' ;;
    "search") cmd=':ObsidianSearch' ;;
    "ledger") cmd=":e $(find ./*personal/*finance/*ledger/ -maxdepth 1 -name "$(date +%Y)"'.ledger' | head -n1)" ;;
esac
exec "$TERMINAL" -e "$EDITOR" -c "$cmd"
