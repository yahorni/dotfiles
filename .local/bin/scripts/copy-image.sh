#!/usr/bin/env dash

set -eu

[ -z "$1" ] && exit

filename="$(readlink -f "$1")"
mime_type="$(file --dereference --brief --mime-type -- "$1")"

if [ "$(echo $mime_type | cut -d'/' -f1)" != "image" ]; then
    notify-send "$filename" "File is not an image"
    exit 1
fi

xclip -selection clipboard -t "$mime_type" -i "$filename" && \
    notify-send -i "$filename" "Copied to clipboard"

echo -n "$filename" | xclip -selection primary && \
    notify-send -i "$filename" "Copied to primary" "$filename"

xclip-copyfile "$filename" && \
    notify-send -i "$filename" "Copied with xclip-copyfile"
