#!/bin/bash

IDE_DIR="${IDE_DIR:-.ide}"
IDE_CONFIGS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/ide"

[ ! -d "$IDE_CONFIGS_DIR" ] && echo "Default files not found: $IDE_CONFIGS_DIR" && exit

mkdir -pv "$IDE_DIR"

defaults=("Makefile" "TODO.md" "ycm.py" ".vimspector.json" ".nvim.lua")

for file in "${defaults[@]}"; do
    [ -f "$IDE_CONFIGS_DIR/$file" ] && cp -i "$IDE_CONFIGS_DIR/$file" "$IDE_DIR"
done

links=(".vimspector.json" ".nvim.lua")

for file in "${links[@]}"; do
    if ! ln -s "$IDE_DIR/$file" . ; then
        echo "Warning: failed to create link to '$file', ignoring"
    fi
done
