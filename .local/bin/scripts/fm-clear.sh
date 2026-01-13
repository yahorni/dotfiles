#!/usr/bin/env dash
[ -p "${FIFO_UEBERZUG:-}" ] &&\
    echo '{"action":"remove","identifier":"preview"}' > "$FIFO_UEBERZUG"
