#!/usr/bin/env dash

set -eu

if [ $# -lt 2 ]; then
    echo "usage: $0 <cmd> <path>"
    echo "  cmd: copy/link/unlink/check"
    exit 1
fi

cmd="$1"
path="$2"
dir="$(dirname "$(realpath --relative-base $HOME/dl "$path")")"

case "$cmd" in
    "copy")
        mkdir -vp "$HOME/mus/copied/$dir"
        cp -vr "$path" "$HOME/mus/copied/$dir"
        ;;
    "link")
        mkdir -vp "$HOME/mus/linked/$dir"
        ln -vsr "$path" "$HOME/mus/linked/$dir"
        ;;
    "unlink")
        rm -vf "$HOME/mus/linked/$dir/$(basename "$path")"
        rmdir -vp "$HOME/mus/linked/$dir" || :
        ;;
    "check")
        find "$HOME/mus/linked/" -xtype l
        ;;
esac
