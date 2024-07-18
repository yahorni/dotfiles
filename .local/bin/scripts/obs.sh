#!/bin/bash
cd "$HOME/dox/obsidian" || exit 1
cmd=
case "$1" in
    "quick") cmd=':ObsidianQuickSwitch' ;;
    "new") cmd=':ObsidianNew' ;;
    "today") cmd=':ObsidianToday' ;;
    "tomorrow") cmd=':ObsidianTomorrow' ;;
    "yesterday") cmd=':ObsidianYesterday' ;;
    "search") cmd=':ObsidianSearch' ;;
    "open") cmd=':ObsidianOpen' ;;
    "ledger") cmd=":e $(find ledger/ -maxdepth 1 -name '*.ledger' | tail -n1)" ;;
esac
exec "$TERMINAL" -e "$EDITOR" -c "$cmd"
