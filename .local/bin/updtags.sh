#!/bin/sh

# NOTE: for system tags use /usr/include
# NOTE: +R (fields) and +r (extras) comes together

if [ "$1" = "-h" -o "$1" = "--help" ]; then
    echo "updtags.sh <directory> <output>"
    echo "    directory - current by default"
    echo "    output - 'tags' by default"
    exit
fi

dir=${1:-.}
out=${2:-tags}

ctags -R \
    --exclude=.git --exclude=node_modules --exclude=build \
    --kinds-c++=+ANUx --fields=+iaSR --extras=+qr \
    --langmap=c++:+.ipp \
    -f ${out} ${dir}
