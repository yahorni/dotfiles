#!/bin/sh

# NOTE: for system tags use /usr/include
# NOTE: +R (fields) and +r (extras) comes together

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "usage $(basename "$0") <directory> <output>"
    echo "    directory - current by default"
    echo "    output - 'tags' by default"
    echo
    echo "example:"
    echo "    updtags.sh /usr/include ~/.local/share/tags"
    exit
fi

dir=${1:-.}
out=${2:-tags}

if command -v ctags-universal 1>/dev/null ; then
  bin="ctags-universal"
elif command -v universal-ctags 1>/dev/null ; then
  bin="universal-ctags"
elif command -v ctags 1>/dev/null ; then
  bin="ctags"
else
  echo "ctags not found"
  exit 1
fi

$bin -R \
    --exclude=.git --exclude=node_modules --exclude=build --exclude=venv \
    --kinds-c++=+ANUx --fields=+iaSR --extras=+qr \
    --langmap=c++:+.ipp --sort=foldcase \
    -f "${out}" "${dir}"
