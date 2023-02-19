#!/bin/bash

emojis_url="https://unicode.org/Public/emoji/latest/emoji-test.txt"
emojis_path="${XDG_DATA_HOME:-$HOME/.local/share}/emojis"

curl "$emojis_url" -o /tmp/emojis.txt
sed -n 's/^.*; fully-qualified\s\+\#\s*\(.*\) E[0-9]\+.[0-9]*/\1/p' /tmp/emojis.txt > "$emojis_path"
