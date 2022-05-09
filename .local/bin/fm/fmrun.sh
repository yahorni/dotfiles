#!/bin/sh

set -e

file_manager="${FM:-lfdir}" # lf/vifm
commands_type="json" # bash/json

cleanup() {
    exec 3>&-
    rm -f "$FIFO_UEBERZUG"
}

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    "$file_manager" "$@"
else
    export FIFO_UEBERZUG="/tmp/fm-ueberzug-$$"
    mkfifo "$FIFO_UEBERZUG"
    ueberzug layer -s <"$FIFO_UEBERZUG" -p "$commands_type" &
    exec 3>"$FIFO_UEBERZUG"
    trap cleanup HUP INT QUIT TERM PWR EXIT
    "$file_manager" "$@" 3>&-
fi
