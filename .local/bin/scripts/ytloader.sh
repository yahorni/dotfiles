#!/bin/bash

set -e

### functions

print_help() {
    echo "Usage: ytloader [options] link"
    echo "Description: downloads music and video from youtube"
    echo "    -h - show help and exit"
    echo "    -f - format."
    echo "         'a' - audio"
    echo "         'l' - low quality video (up to 240p)"
    echo "         'm' - medium quality video (up to 1080p) [default]"
    echo "         'h' - high quality video (best quality available)"
    echo "    -s - download video with subtitles (if available)"
    echo "    -d - subdirectory for file. Appends to default music/video path"
    echo "    -u - add uploader at the title"
    echo "    -p - for playlists: first video to download from"
    echo "    -c - path to cookies file"
    echo "    -S - do not check for SSL certificates"
}

notify() {
    if [ -z "$DISPLAY" ] || command -v notify-send >/dev/null; then
        echo "$@"
    else
        notify-send "$@"
    fi
}

parse_args() {
    OPTIND=1
    while getopts "f:d:p:c:sSuA:h" opt; do
        case $opt in
            f) format=$OPTARG ;;
            d) subdir=$OPTARG ;;
            p) other_args+=("--playlist-start" "$OPTARG") ;;
            s) other_args+=("--all-subs") ;;
            c) other_args+=("--cookies" "$OPTARG") ;;
            S) other_args+=("--no-check-certificates") ;;
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
    if [ "$format" == 'a' ]; then
        download_dir="${audio_dir}/${subdir}"
    else
        download_dir="${video_dir}/${subdir}"
    fi
    mkdir -p "$download_dir"
}

check_error() {
    error_code="$?"
    [ $error_code -ne 0 ] && notify "$msg_fail" "Error code ($error_code)\n$link" && exit $error_code
}

download() {
    notify "$msg_download" "$link"

    download_cmd=(yt-dlp --add-metadata --ignore-errors --continue "${other_args[@]}" --output "$download_dir/$filename")
    case $format in
        'a') "${download_cmd[@]}" --format "bestaudio" "${thumb_args[@]}" "${audio_args[@]}" "$link" ;;
        'l') "${download_cmd[@]}" --format "best[height<=360]" "$link" ;;
        'm') "${download_cmd[@]}" --format "bestvideo[height<=1080]+bestaudio/best" "$link" ;;
        'h') "${download_cmd[@]}" "$link" ;;
        *) notify "$msg_invalid_format" "Format ($format)\n$link" ; exit 1 ;;
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
subdir="downloads"

thumb_args=(--embed-thumbnail --ppa "EmbedThumbnail+ffmpeg_o:-c:v mjpeg -vf crop=\"'if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)'\"")
audio_args=(-x --audio-format mp3 --audio-quality 320k)

### variables

declare -a other_args
filename='%(title).80s.%(ext)s'
format="m"
link=""
download_dir=""

### main

parse_args "$@"
set_download_dir
download
