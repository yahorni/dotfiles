#!/bin/bash

IDE_DIR="${IDE_DIR:-.ide}"
IDE_CONFIGS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/ide"

mkdir -pv "$IDE_DIR"

declare -A basic_files=(
    ['TODO.md']='# TODO'
    ['plugins.vim']='" vim plugins for project'
    ['options.vim']='" vim options for project'
)

for file in "${!basic_files[@]}"; do
    [ ! -f "$IDE_DIR/$file" ] && echo "${basic_files[$file]}" > "$IDE_DIR/$file"
done

[ ! -d "$IDE_CONFIGS_DIR" ] && echo "Default files not found: $IDE_CONFIGS_DIR" && exit

[ -f "$IDE_CONFIGS_DIR/Makefile" ]          && cp -i "$IDE_CONFIGS_DIR/Makefile" "$IDE_DIR"
[ -f "$IDE_CONFIGS_DIR/ycm.py" ]            && cp -i "$IDE_CONFIGS_DIR/ycm.py" "$IDE_DIR"
[ -f "$IDE_CONFIGS_DIR/.vimspector.json" ]    && cp -i "$IDE_CONFIGS_DIR/.vimspector.json" "$IDE_DIR"

if ! ln -s "$IDE_DIR/.vimspector.json" . ; then
    echo "Failed to create vimspector link, ignore"
fi
