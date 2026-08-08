#!/usr/bin/env bash
set -eu
check-binaries.sh xclip trans

word="$(xclip -o -sel pri)"
langs="${1:-en:ru}"
mode="${2:-}"
extended=false

declare -a args
if [ "$mode" = "-s" ] || [ "$mode" = "--speak" ]; then
    args+=("-speak")
elif [ "$mode" = "-e" ] || [ "$mode" = "--extended" ]; then
    extended=true
fi

if [ "$extended" = "true" ]; then
    floating-terminal.sh -e sh -c "trans '$langs' '$word' | less"
else
    translation="$(trans "$langs" -brief "$word" "${args[@]}")"
    notify-send -t 8000 "$word" "$translation"
fi
