#!/bin/bash

kw_args=()
pos_args=()
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -d|--dirs)
      IFS=',' read -r -a ignored_dirs <<< "$2"
      shift
      shift
      ;;
    *)
      pos_args+=("$1")
      shift
      ;;
  esac
done

for dir in "${ignored_dirs[@]}"; do
  kw_args+=("-g" "!$dir")
done

rg --vimgrep -F -S --hidden --no-messages \
    -g '!.git' -g '!build' -g '!node_modules' \
    "${kw_args[@]}" \
    "${pos_args[@]}"
