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
    while getopts "f:d:p:c:suSh" opt; do
        case $opt in
            f) format=$OPTARG ;;
            d) subdir=$OPTARG ;;
            p) other_args+=("--playlist-start" "$OPTARG") ;;
            s) other_args+=("--all-subs") ;;
            c) other_args+=("--cookies" "$OPTARG") ;;
            S) other_args+=("--no-check-certificates") ;;
            u) filename='%(uploader)s - %(title).80s.%(ext)s' ;;
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
        filename="%(playlist_index)s. $filename"
    fi
}

check_download_dir() {
    video_dir="${video_dir}/${subdir}"
    audio_dir="${audio_dir}/${subdir}"

    if [ "$format" == 'a' ]; then
        mkdir -p "$audio_dir"
    else
        mkdir -p "$video_dir"
    fi
}

check_error() {
    error_code="$?"
    [ $error_code -ne 0 ] && notify "$msg_fail" "Error code ($error_code)\n$link" && exit $error_code
}

download() {
    notify "$msg_download" "$link"

    case $format in
        'a') "$downloader" --add-metadata "${thumb_args[@]}" -icxf "bestaudio" --audio-format mp3 --audio-quality 320k -o "$audio_dir/$filename" "$link" ;;
        'd') "$downloader" --add-metadata "${other_args[@]}" -ic -o "$video_dir/$filename" "$link" ;;
        'l') "$downloader" --add-metadata "${other_args[@]}" -icf "best[height<=360]" -o "$video_dir/$filename" "$link" ;;
        'm') "$downloader" --add-metadata "${other_args[@]}" -icf "bestvideo[height<=1080]+bestaudio/best" -o "$video_dir/$filename" "$link" ;;
        'h') "$downloader" --add-metadata "${other_args[@]}" -icf "bestvideo+bestaudio/best" -o "$video_dir/$filename" "$link" ;;
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

downloader="yt-dlp" # youtube-dl
thumb_args=(--embed-thumbnail --ppa "EmbedThumbnail+ffmpeg_o:-c:v mjpeg -vf crop=\"'if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)'\"")

### variables

declare -a other_args
filename='%(title)s.%(ext)s'
format="m"
link=""

### main

parse_args "$@"
check_download_dir
download
