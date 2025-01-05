#!/bin/bash
cd "$HOME/dox/obsidian" || exit 1
cmd=
case "$1" in
    "quick") cmd=':ObsidianQuickSwitch' ;;
    "new") cmd=':ObsidianNew' ;;
    "today") cmd=':ObsidianToday' ;;
    "tomorrow") cmd=':ObsidianToday +1' ;;
    "yesterday") cmd=':ObsidianToday -1' ;;
    "search") cmd=':ObsidianSearch' ;;
    "open") cmd=':ObsidianOpen' ;;
    "ledger") cmd=":e $(find ./*personal/*finance/*ledger/ -maxdepth 1 -name "$(date +%Y)"'.ledger' | head -n1)" ;;
esac
exec "$TERMINAL" -e "$EDITOR" -c "$cmd"
