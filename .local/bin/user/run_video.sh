#!/bin/bash
# vim:ts=2:sw=2:sts=2

### variables ###
bottom_sub_sid=
top_sub_sid=
audio_sid=
delay_sec=
sub_pos=
sub_scale=
offset=

# $1 - number of series
if [ -n "$1" ]; then
  index=$1
  shift
  # preconfigure for series
  [ -n "$offset" ] && offset=$((offset + index))
  # uncomment if needed: '1' -> '01'
  index=$(printf "%02d" "$index")
fi

# fill the names of the files below with $offset and $index if they needed
video=
audio1=
audio2=
bottom_sub=
top_sub=

### configure ###
cmd=(mpv)
[ -n "$bottom_sub_sid" ]  && cmd+=(--sid="$bottom_sub_sid")
[ -n "$top_sub_sid" ]     && cmd+=(--secondary-sid="$top_sub_sid")
[ -n "$audio_sid" ]       && cmd+=(--audio="$audio_sid")
[ -n "$delay_sec" ]       && cmd+=(--sub-delay="$delay_sec")
[ -n "$sub_pos" ]         && cmd+=(--sub-pos="$sub_pos")
[ -n "$sub_scale" ]       && cmd+=(--sub-scale="$sub_scale")
[ -n "$audio1" ]          && [ -f "$audio1" ]     && cmd+=(--audio-file="$audio1")
[ -n "$audio2" ]          && [ -f "$audio2" ]     && cmd+=(--audio-file="$audio2")
[ -n "$bottom_sub" ]      && [ -f "$bottom_sub" ] && cmd+=(--sub-file="$bottom_sub")
[ -n "$top_sub" ]         && [ -f "$top_sub" ]    && cmd+=(--sub-file="$top_sub")
cmd+=("$video")

### run ###
"${cmd[@]}" "$@"
