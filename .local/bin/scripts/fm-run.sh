#!/usr/bin/env dash

set -eu

file_manager="${FM:-fm-lfdir.sh}"

cleanup() {
    exec 3>&-
    rm -f "$FIFO_UEBERZUG"
}

if [ -n "${SSH_CLIENT:-}" ] || [ -n "${SSH_TTY:-}" ]; then
    "$file_manager" "$@"
elif ! command -v ueberzug >/dev/null 2>/dev/null ; then
    "$file_manager" "$@"
else
    export FIFO_UEBERZUG="/tmp/fm-ueberzug-$$"
    mkfifo "$FIFO_UEBERZUG"
    ueberzug layer -s <"$FIFO_UEBERZUG" -p "json" &
    exec 3>"$FIFO_UEBERZUG"
    trap cleanup HUP INT QUIT TERM PWR EXIT
    "$file_manager" "$@" 3>&-
fi
