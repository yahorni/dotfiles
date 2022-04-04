#!/bin/bash

export PATH="$PATH:$HOME/.local/bin/wm"

{ pgrep -x mpd || mpd & } &>/dev/null
