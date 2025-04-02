#!/bin/bash

echo "Audio note: ffmpeg..."
echo "Press Ctrl-C to stop recording"
ffmpeg -y -hide_banner -loglevel error -f pulse -i default -ar 16000 /tmp/audio2txt.wav

echo "Audio note: whisper.cpp..."
time whisper-cli \
    --no-prints --no-timestamps \
    --threads 10 \
    --language ru \
    --model "$HOME/prj/whisper.cpp/ggml-medium-q8_0.bin" \
    /tmp/audio2txt.wav |\
    xclip -in -sel cli

echo "Audio note: sleep 1s to update greenclip..."
sleep 1s
