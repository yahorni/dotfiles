#!/bin/bash

word="$(xclip -o -sel pri)"
langs="$1"
extended=false

declare -a args
if [ "$2" = "-s" ] || [ "$2" = "--speak" ]; then
    args+=("-speak")
elif [ "$2" = "-e" ] || [ "$2" = "--extended" ]; then
    extended=true
fi

if [ "$extended" = "true" ]; then
    $TERMINAL -c dropdown -e sh -c "trans '$langs' '$word' | less"
else
    translation="$(trans "$langs" -brief "$word" "${args[@]}")"
    notify-send -t 8000 "$word" "$translation"
fi
