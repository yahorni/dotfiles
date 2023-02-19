#!/bin/bash

IDE_DIR="${IDE_DIR:-.ide}"
IDE_CONFIGS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/ide"

mkdir -pv "$IDE_DIR"

echo '# TODO' > "$IDE_DIR/TODO.md"
echo '" vim plugins for project' > "$IDE_DIR/plugins.vim"
echo '" vim options for project' > "$IDE_DIR/options.vim"

[ ! -d "$IDE_CONFIGS_DIR" ] && echo "default files not found" && exit

[ -f "$IDE_CONFIGS_DIR/Makefile" ] && cp "$IDE_CONFIGS_DIR/Makefile" "$IDE_DIR"
[ -f "$IDE_CONFIGS_DIR/ycm.py" ] && cp "$IDE_CONFIGS_DIR/ycm.py" "$IDE_DIR"

echo '{}' > "$IDE_DIR/.vimspector.json"
ln -s "$IDE_DIR/.vimspector.json" .
