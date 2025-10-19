#!/usr/bin/env bash

# vifm
# %d  current directory
# %c  current file
# %pw width of preview area
# %ph height of preview area
# %px x coordinate of top-left corner of preview area
# %py y coordinate of top-left corner of preview area

# lf
# (1) current file name
# (2) width
# (3) height
# (4) horizontal position of preview pane
# (5) vertical position of preview pane

set -euo pipefail

preview_text() {
    local filename="$1"
    if command -v bat >/dev/null 2>&1 ; then
        bat --terminal-width $((width-2)) -f "$filename"
    elif command -v highlight >/dev/null 2>&1 ; then
        highlight -t 4 -O ansi "$filename"
    else
        cat "$filename"
    fi
}

preview_html() {
    local filename="$1"
    if command -v lynx >/dev/null 2>&1 ; then
        lynx -width="$x_pos" -display_charset=utf-8 -dump "$filename"
    else
        preview_text "$filename"
    fi
}

preview_zip() {
    local filename="$1"
    if command -v atool >/dev/null 2>&1 ; then
        atool --list -- "$filename"
    else
        zip -sf "$filename"
    fi
}

print_preview() {
    case "$mime_type" in
        text/html)                          preview_html "$filename" ;;
        text/troff)                         man ./"$filename" | col -b ;;
        text/*|*/xml|application/json|application/x-ndjson|application/javascript|application/pgp-encrypted|application/mbox)
                                            preview_text "$filename" || cat "$filename" ;;
        audio/*|application/octet-stream)   mediainfo "$filename" ;;
        application/zip)                    preview_zip "$filename" ;;
        application/gzip)                   tar -tzf "$filename" ;;
        application/x-tar)                  tar -tf "$filename" ;;
        application/x-rar|application/vnd.rar)
                                            unrar v "$filename" ;;
        *opendocument*)                     odt2txt "$filename" ;;
        application/vnd.openxmlformats*)    docx2txt "$filename" - ;;
        application/pdf)                    pdftotext -nopgbrk "$filename" - ;;
        *)                                  file --dereference -- "$(basename "$filename")" ;;
    esac
}

get_file_hash() {
    stat --printf '%n\0%i\0%F\0%s\0%W\0%Y' -- "$(readlink -f "$filename")" | sha256sum | cut -d' ' -f1
}

generate_preview_image() {
    if [[ ( "$mime_type" = "image/"* ) && ( "$mime_type" != *"djvu" ) ]]; then
        preview_path="$filename"
        return
    fi

    preview_path="$preview_cache_dir/$(get_file_hash)"
    if [ -f "$preview_path" ]; then
        return 0
    fi

    mkdir -p "$preview_cache_dir" >/dev/null 2>&1
    case "$mime_type" in
        video/*) ffmpegthumbnailer -i "$filename" -o "$preview_path" -s 0 -q 10 ;;
        */pdf)
            pdftoppm -f 1 -l 1 \
                -scale-to-x 800 -scale-to-y -1 \
                -singlefile \
                -jpeg -tiffcompression jpeg -- "$filename" "$preview_path"
            mv "$preview_path".* "$preview_path"
            ;;
        *djvu) ddjvu "$filename" -page=1 -format=ppm -size=800x600 "$preview_path" ;;
        */epub+zip|*/mobi*) gnome-epub-thumbnailer "$filename" "$preview_path" ;;
    esac
}

draw_preview_image() {
    if [ -f "$preview_path" ]; then
        if [ "$commands_type" = "bash" ]; then
            declare -p -A _=([action]=add [identifier]=$identifier [x]=$x_pos [y]=$y_pos [width]=$width
                             [height]=$height [scaler]=contain [path]="$preview_path") >"$FIFO_UEBERZUG"
        elif [ "$commands_type" = "json" ]; then
            printf '{"action": "add", "identifier": "%s", "x": "%s", "y": "%s", "width": "%s", "height": "%s", "scaler": "contain", "path": "%s"}\n' \
                "$identifier" "$x_pos" "$y_pos" "$((width-1))" "$((height-1))" "$preview_path" > "$FIFO_UEBERZUG"
        else
            return 1
        fi
    else
        print_preview
    fi
}

is_ueberzug_running() {
    command -v ueberzug >/dev/null 2>&1 && [ -p "${FIFO_UEBERZUG:-}" ]
}

is_drawable_preview() {
    case "$mime_type" in
        video/*|image/*|*/pdf|*djvu|*/epub+zip|*/mobi*) return 0 ;;
        *) return 1 ;;
    esac
}

### declarations ###

x_pos=${4:-}
y_pos=${5:-}
width=${2:-}
height=${3:-}
filename="$1"

preview_path=

preview_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/fmpreview"
mime_type="$(file --dereference --brief --mime-type -- "$filename")"

identifier="preview"
commands_type="json" # bash/json

### main ###

if [ -n "${DISPLAY:-}" ] && [ -z "${WAYLAND_DISPLAY:-}" ] && is_ueberzug_running && is_drawable_preview; then
    generate_preview_image
    draw_preview_image
else
    print_preview
fi

exit 1
