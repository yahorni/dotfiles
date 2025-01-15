#!/bin/bash

if [ -z "$1" ]; then
    url="$(xclip -o)"
else
    url="$1"
fi

case "$url" in
    *youtube\.com/watch*|*youtu\.be*|*youtube\.com/shorts*|*youtube\.com/live*|\
    *\.mkv|*\.webm|*\.mp4|*\.3gp|*\.avi|\
    *\.mp4?*|\
    *vk.com/video-*)
        notify-send "Opening in MPV" "$url"
        ERROR=$( (yt-dlp -F "$url" 3>&2 2>&1 1>&3) 2>/dev/null)
        [[ "$?" -ne "0" ]] && notify-send "Youtube-dl error" "$ERROR" && exit 1
        exec mpv --ytdl-format="bestvideo[height<=1080]+bestaudio/best[height<=1080]"\
            --really-quiet --osc "$url" & ;;
    *\.png|*\.jpg|*\.jpeg|*\.gif|*\.webp)
        curl -sL "$url" > "/tmp/linkhandler.image" && exec nsxiv -a "/tmp/linkhandler.image" & ;;
    *\.pdf)
        curl -sL "$url" > "/tmp/linkhandler.pdf" && exec zathura "/tmp/linkhandler.pdf" & ;;
    *)
        exec "$BROWSER" "$url" >/dev/null 2>&1 ;;
esac &
