#!/bin/bash
# vim: ts=2 sw=2 sts=2

# For gutentags support:
# * `-f` (to specify the output file)
# * `--append` (to append to an existing file while keeping it sorted)
# * `--exclude` (to exclude file patterns)
# * `--options` (to specify an options file)

pos_args=()
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -f)
      output_file="$2"
      shift
      shift
      ;;
    # ignore positional options
    --options=*|--tag-relative=*)
      shift
      ;;
    # ignore kw options
    --options|--tag-relative)
      shift
      shift
      ;;
    *)
      pos_args+=("$1")
      shift
      ;;
  esac
done

exec updtags.sh "$output_file" "${pos_args[@]}"
