#!/bin/bash

IDE_DIR="${IDE_DIR:-.ide}"

mkdir -pv "$IDE_DIR"

echo '# TODO' > "$IDE_DIR/TODO.md"
echo '" local vim setup' > "$IDE_DIR/init.vim"

default_files="$HOME/.config/ide"
[ ! -d "$default_files" ] && echo "default files not found" && exit

[ -f "$default_files/Makefile" ] && cp ~/.config/ide/Makefile "$IDE_DIR"
[ -f "$default_files/ycm.py" ] && ln -s ~/.config/ide/ycm.py "$IDE_DIR"
