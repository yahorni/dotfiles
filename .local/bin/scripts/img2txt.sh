#!/bin/bash
set -eo pipefail
# $1 = eng/rus/eng+rus, default = eng
maim -s -u |\
    tesseract -l "${1:-eng}" - - |\
    xclip -in -selection clipboard -filter |\
    xclip -in -selection primary
notify-send "Copied text from screenshot"
