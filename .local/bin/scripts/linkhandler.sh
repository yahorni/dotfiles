#!/usr/bin/env dash

set -eu

if [ -z "${1:-}" ]; then
    url="$(xclip -o)"
else
    url="$1"
fi

case "$url" in
    *youtube\.com/watch*|*youtu\.be*|*youtube\.com/shorts*|*youtube\.com/live*|\
    *\.mkv|*\.webm|*\.mp4|*\.3gp|*\.avi|\
    *vk.com/video-*)
        notify-send "Open with yt-dlp + mpv" "$url"
        if ! ERROR=$(yt-dlp -F "$url" 2>&1 >/dev/null ); then
            notify-send "yt-dlp error" "$(echo "$ERROR" | grep "ERROR:")"
            exit 1
        fi
        exec mpv --ytdl-format="bestvideo[height<=1080]+bestaudio/best[height<=1080]" --really-quiet --osc "$url"
        ;;
    *\.png|*\.jpg|*\.jpeg|*\.gif|*\.webp)
        curl -sL "$url" > "/tmp/linkhandler.image"
        exec nsxiv -a "/tmp/linkhandler.image"
        ;;
    *\.pdf)
        curl -sL "$url" > "/tmp/linkhandler.pdf"
        exec zathura "/tmp/linkhandler.pdf"
        ;;
    *)
        exec "$BROWSER" "$url"
        ;;
esac
