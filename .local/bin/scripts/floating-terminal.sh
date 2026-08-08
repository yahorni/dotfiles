#!/bin/sh
case "$TERMINAL" in
    st) exec st -c floating "$@" ;;
    xterm) exec xterm -class floating "$@" ;;
    *) exec "$TERMINAL" --class floating "$@" ;;
esac
