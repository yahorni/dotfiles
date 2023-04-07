#!/bin/bash

categories="Downloads\nFilms\nMusic\nSeries\nBooks\nMusic (subdir.)\nCustom..."
directory=
music_directory="$(xdg-user-dir MUSIC)"

notify() { notify-send "🔽 Add torrent" "$1" ;}

case $(echo -e $categories | dmenu -i -p "Option:") in
    Films)      directory="$(xdg-user-dir VIDEOS)" ;;
    Music)      directory="$music_directory" ;;
    Series)     directory="$(xdg-user-dir SERIES)" ;;
    Books)      directory="$(xdg-user-dir BOOKS)" ;;
    Downloads)  directory="$(xdg-user-dir DOWNLOAD)" ;;
    M*subdir*)  directory="$music_directory"/"$(ls "$music_directory" | dmenu -l 20 -p "Choose subdir in '$music_directory':")" ;;
    Custom*)    directory="$HOME/$(dmenu -p "Enter path in '$HOME':" <&-)" ;;
    "")         notify "Canceled torrent" && exit ;;
    *)          notify "Invalid directory" && exit ;;
esac

[ -z "$directory" ] && notify "Empty directory path" && exit
[ ! -d "$directory" ] && mkdir -p "$directory"

pgrep -x transmission-da || \
    (transmission-daemon && notify "Starting transmission daemon..." && sleep 3)
transmission-remote -a "$@" -w "$directory" && \
    notify "Added to: $directory"
