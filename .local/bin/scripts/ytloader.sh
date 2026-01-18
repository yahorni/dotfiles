#!/usr/bin/env bash

set -euo pipefail

### examples:
# Download track:
# ytloader.sh -f a -d manual/_various -A 1 https://music.youtube.com/watch?v=<video_id>
# Download album:
# ytloader.sh -f a -d "manual/The Drums" -A 1 https://music.youtube.com/playlist?list=<playlist_id>

### functions

print_help() {
    echo "Usage: ytloader [options] link"
    echo "Description: downloads music and video from youtube"
    echo "    -h - show help and exit"
    echo "    -f - format."
    echo "         'a' - audio"
    echo "         'l' - low quality video (up to 240p)"
    echo "         'n' - medium quality video (up to 1080p) [default]"
    echo "         'o' - high quality video/audio, format not specified (best quality available)"
    echo "    -s - download video with subtitles (if available)"
    echo "    -d - subdirectory for file. Appends to default music/video path"
    echo "    -u - add uploader at the title"
    echo "    -p - for playlists: first video to download from"
    echo "    -c - path to cookies file"
    echo "    -S - do not check for SSL certificates"
    echo "    -A - add 1, 2 or 3 author to filename"
    echo "    -D - remove 'Date' tag from songs"
}

notify() {
    local title="$1"
    local body="$2"
    if [ -n "${DISPLAY:-}" ] && command -v notify-send >/dev/null; then
        notify-send "$title" "$body"
    else
        echo "$title: $body"
    fi
}

parse_args() {
    OPTIND=1
    while getopts "f:d:p:c:sSDuA:h" opt; do
        case $opt in
            f) if [ "$OPTARG" == "a" ] ||\
                  [ "$OPTARG" == "l" ] ||\
                  [ "$OPTARG" == "n" ] ||\
                  [ "$OPTARG" == "o" ]; then
                   format=$OPTARG
               else
                   notify "$msg_invalid_format" "value: '$OPTARG'" && exit 1
               fi ;;
            d) subdir=$OPTARG ;;
            p) other_args+=("--playlist-start" "$OPTARG") ;;
            s) other_args+=("--all-subs") ;;
            c) other_args+=("--cookies" "$OPTARG") ;;
            S) other_args+=("--no-check-certificates") ;;
            D) other_args+=("${date_args[@]}") ;;
            u) filename="%(uploader)s - $filename" ;;
            A) if [ "$OPTARG" -eq 1 ]; then
                   filename="%(artist)s - $filename"
               elif [ "$OPTARG" -eq 2 ]; then
                   filename="%(artists.0)s & %(artists.1)s - $filename"
               else
                   filename="%(artists.0)s, %(artists.1)s & %(artists.2)s - $filename"
               fi ;;
            h) print_help ; exit 0 ;;
            *) notify "$msg_invalid_flag" && exit 1 ;;
        esac
    done

    shift $((OPTIND-1))
    link=$1

    if [ -z "$link" ]; then
        echo "$msg_no_url"
        notify "$msg_no_url"
        print_help
        exit 1
    elif [[ "$link" == *"playlist?list"* ]]; then
        filename="%(playlist)s/%(playlist_index)s. $filename"
        other_args+=('--parse-metadata' 'playlist_index:%(track_number)s')
    fi
}

set_download_dir() {
    if [ "$format" == 'o' ]; then
        destination_dir="${download_dir}"
    elif [ "$format" == 'a' ]; then
        destination_dir="${audio_dir}/${subdir}"
    else
        destination_dir="${video_dir}/${subdir}"
    fi
    mkdir -p "$destination_dir"
}

check_error() {
    error_code="$?"
    [ $error_code -ne 0 ] && notify "$msg_fail" "Error code ($error_code)\n$link" && exit $error_code
}

download() {
    notify "$msg_download" "$link"

    download_cmd=(yt-dlp --add-metadata --ignore-errors --continue "${other_args[@]}" --output "$destination_dir/$filename")
    case $format in
        'a') "${download_cmd[@]}" --format "bestaudio" "${thumb_args[@]}" "${audio_args[@]}" "$link" ;;
        'l') "${download_cmd[@]}" --format "best[height<=360]" "$link" ;;
        'n') "${download_cmd[@]}" --format "bestvideo[height<=1080]+bestaudio/best" "$link" ;;
        'o') "${download_cmd[@]}" "$link" ;;
        *) notify "$msg_invalid_format" "Format ($format)\n$link" && exit 1 ;;
    esac ; check_error

    notify "$msg_loaded" "$link"
}

### constants

msg_download="YTLoader: Downloading"
msg_no_url="YTLoader: No URL given"
msg_fail="YTLoader: Download failed"
msg_invalid_format="YTLoader: Invalid format"
msg_loaded="YTLoader: Loaded"
msg_invalid_flag="YTLoader: Invalid option"

video_dir="$(xdg-user-dir VIDEOS)"
audio_dir="$(xdg-user-dir MUSIC)"
download_dir="$(xdg-user-dir DOWNLOAD)"
subdir="downloads"

thumb_args=(--embed-thumbnail --ppa "EmbedThumbnail+ffmpeg_o:-c:v mjpeg -vf crop=\"'if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)'\"")
audio_args=(-x --audio-format mp3 --audio-quality 320k)
# postprocessor-args to remove "Date" metadata tag
date_args=(--postprocessor-args "ffmpeg:-metadata date=")

### variables

declare -a other_args
filename='%(title).80s.%(ext)s'
format="n"
link=""
destination_dir=""

### main

parse_args "$@"
set_download_dir
download
