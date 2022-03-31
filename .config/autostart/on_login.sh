#!/bin/bash

{ pgrep -x mpd || mpd & } &>/dev/null
