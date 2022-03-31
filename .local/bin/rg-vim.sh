#!/bin/sh

# TODO: add support for custom dirs like 'tests/'

rg --vimgrep -F --hidden --no-messages \
    -g '!venv' \
    -g '!build' \
    -g '!.git' \
    -g '!ci' \
    "$@"
