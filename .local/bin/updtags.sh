#!/bin/sh

# NOTE: for system tags use /usr/include
# NOTE: +R (fields) and +r (extras) comes together

dir=${1:-.}
out=${2:-tags}

ctags -R \
    --exclude=.git --exclude=node_modules --exclude=build \
    --kinds-c++=+ANUx --fields=+iaSR --extras=+qr \
    -f ${out} ${dir}
