#!/bin/sh

lf_cache="${XDG_CACHE_HOME:-$HOME/.cache}/lf"
last_dir_file="${lf_cache}/last_dir"

if [ ! -d "$lf_cache" ]; then
    # create cache directory
    mkdir -p "$lf_cache"
elif [ -f "$last_dir_file" ]; then
    # shellcheck disable=SC2155
    last_dir="$(cat "$last_dir_file")"
fi

# take dirname in case last_dir doesn't exist
[ -n "$last_dir" ] && [ ! -d "$last_dir" ] && last_dir=$(dirname "$last_dir")

exec lf --last-dir-path "$last_dir_file" "$last_dir"
