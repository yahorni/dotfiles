#!/bin/dash
maim -s -u |\
    tesseract -l eng+rus - - |\
    xclip -in -selection clipboard -filter |\
    xclip -in -selection primary
notify-send "Copied text from screenshot"
