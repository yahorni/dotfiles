#!/usr/bin/env dash
set -eu

for bin in "$@"; do
    if ! command -v "$bin" >/dev/null; then notify-send "$bin not found"; exit 2; fi
done
