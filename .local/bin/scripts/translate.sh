#!/bin/bash

word="$(xclip -o -sel pri)"
langs="$1"
full=false
declare -a args
if [ "$2" = "-s" ]; then
    args+=("-speak")
elif [ "$2" = "-f" ]; then
    full=true
fi

if [ "$full" = "false" ]; then
    translation="$(trans "$langs" -brief "$word" "${args[@]}")"
    notify-send -t 8000 "$word" "$translation"
else
    $TERMINAL -c dropdown -e sh -c "trans '$langs' '$word' | less"
fi
