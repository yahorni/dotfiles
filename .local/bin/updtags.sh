#!/bin/bash

# NOTE: +R (fields) and +r (extras) comes together

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "usage $(basename "$0") <output> <directory>..."
    echo "    output - 'tags' by default"
    echo "    directory - current by default"
    echo
    echo "example:"
    echo "    updtags.sh ~/.local/share/tags /usr/include"
    exit
fi

if [ "$1" = "--system" ]; then
    output=tags
    shift
    directories=("/usr/include" $(find /usr/lib -maxdepth 1 -name "python*"))
else
    output=${1:-tags}
    shift
    directories=("${@:-.}")
fi

if command -v ctags-universal 1>/dev/null ; then
  bin="ctags-universal"
elif command -v universal-ctags 1>/dev/null ; then
  bin="universal-ctags"
elif command -v ctags 1>/dev/null ; then
  bin="ctags"
else
  echo "ctags not found" 1>&2
  exit 1
fi

$bin -R \
    --exclude=.git --exclude=.nvim \
    --exclude=node_modules --exclude=build --exclude=venv \
    --fields=+iaSRl --extras=+qr \
    --sort=foldcase \
    --kinds-c++=+ANUx --langmap=c++:+.ipp \
    --kinds-python=-iv \
    -f "${output}" "${directories[@]}"
