#!/usr/bin/env bash

set -eu

declare cmd abs_path album_dir link

print_usage_and_exit() {
    local script_name="$(basename "$0")"
    echo "usage: $script_name <cmd> <abs_path>"
    echo "  commands:"
    echo "  1. copy/link/unlink - to manipulate directories:"
    echo "  $ $script_name <command> <abs_path>"
    echo "  2. check - to find broken links:"
    echo "  $ $script_name check"
    echo "  3. song/album - to download song/album:"
    echo "  $ $script_name <command> <song link/album link> [album author]"
    exit 1
}

parse_cmd() {
    if [ $# -lt 1 ]; then
        print_usage_and_exit
    fi

    cmd="$1"
}

parse_copy_link_unlink_args() {
    if [ $# -lt 2 ]; then
        print_usage_and_exit
    fi

    abs_path="$2"
    album_dir="$(dirname "$(realpath --relative-base $HOME/dl "$abs_path")")"
}

parse_song_album_args() {
    if [ $# -lt 2 ]; then
        print_usage_and_exit
    fi

    link="$2"
    album_dir="${3:-various}"
}

parse_cmd "$@"
case "$cmd" in
    "copy")
        parse_copy_link_unlink_args "$@"
        mkdir -vp "$HOME/mus/copied/$album_dir"
        cp -vr "$abs_path" "$HOME/mus/copied/$album_dir"
        ;;
    "link")
        parse_copy_link_unlink_args "$@"
        mkdir -vp "$HOME/mus/linked/$album_dir"
        ln -vsr "$abs_path" "$HOME/mus/linked/$album_dir"
        ;;
    "unlink")
        parse_copy_link_unlink_args "$@"
        rm -vf "$HOME/mus/linked/$album_dir/$(basename "$abs_path")"
        rmdir -vp "$HOME/mus/linked/$album_dir" || :
        ;;
    "check")
        find "$HOME/mus/linked/" -xtype l
        ;;
    "song")
        parse_song_album_args "$@"
        format='a'
        if [[ $link == *"soundcloud"* ]]; then
            format='o'
        fi
        ytloader.sh -A 1 -D -f "$format" -d "manual/$album_dir" "$link"
        ;;
    "album")
        parse_song_album_args "$@"
        ytloader.sh -A 1 -f a -d "manual/$album_dir" "$link"
        ;;
esac
