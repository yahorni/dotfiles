#!/bin/sh

word="$(xsel -op)"
if [ "$1" = "-v" ]; then
    translation="$(trans fr:en --brief "$word" -speak)"
else
    translation="$(trans fr:en --brief "$word")"
fi
notify-send -t 8000 "$word" "$translation"
