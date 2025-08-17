#!/usr/bin/env dash

set -eu

cd "$HOME/dox/notes"

case "$1" in
    "today")    cmd="Obsidian today" ;;
    "tomorrow") cmd="Obsidian tomorrow" ;;
    "yesterday")cmd="Obsidian yesterday" ;;
    "ledger")   file="$(find ./*personal/*finance/*ledger/ -maxdepth 1 -name "$(date +%Y)"'.ledger' | head -n1)" ;;
    "files")    cmd="FzfLua files" ;;
    "search")   cmd="FzfLua live_grep" ;;
esac

if [ -n "${file:-}" ]; then
    exec "$TERMINAL" -e "$EDITOR" "$file"
elif [ -n "${cmd:-}" ]; then
    exec "$TERMINAL" -e "$EDITOR" -c "$cmd"
else
    exec "$TERMINAL" -e "$EDITOR"
fi
