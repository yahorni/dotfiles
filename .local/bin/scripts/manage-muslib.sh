#!/usr/bin/env dash

set -eu

if [ $# -lt 2 ]; then
    echo "usage: $0 <cmd> <path>"
    echo "  cmd: copy/link/unlink"
    exit 1
fi

cmd="$1"
path="$2"
dir="$(dirname "$(realpath --relative-base ~/dl "$path")")"

case "$cmd" in
    "copy")
        mkdir -vp ~/mus/copied/"$dir"
        cp -vr "$path" ~/mus/copied/"$dir"
        ;;
    "link")
        mkdir -vp ~/mus/linked/"$dir"
        ln -vsr "$path" ~/mus/linked/"$dir"
        ;;
    "unlink")
        rm -vf ~/mus/linked/"$dir/$(basename "$path")"
        rmdir -vp ~/mus/linked/"$dir" || :
        ;;
esac
