#!/bin/sh

identifier="preview"
commands_type="json" # bash/json

if [ ! -p "$FIFO_UEBERZUG" ]; then
    exit 1
fi

case "$commands_type" in
    bash) declare -p -A _=([action]=remove [identifier]="$identifier") >"$FIFO_UEBERZUG" ;;
    json) printf '{"action": "remove", "identifier": "%s"}\n' "$identifier" > "$FIFO_UEBERZUG" ;;
esac
