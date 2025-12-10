#!/usr/bin/env bash

set -eu

hdd="/mnt/usb1"

sync_command=(rsync -avh --delete --exclude '.stfolder/')

sync_folder() {
    echo "--------------------------------------------------------------------------------"
    local src="$1" dst="$hdd/$2"
    echo "Backup: '$src' -> '$dst'"
    mkdir -p "$dst"
    "${sync_command[@]}" "$src" "$dst"
}

sync_folder ~/dox/files/            "dox/files/"
sync_folder ~/dox/notes/            "dox/notes/"
sync_folder ~/dox/job/              "dox/job/"
sync_folder ~/dox/phone/            "dox/phone/"
sync_folder ~/mus/manual/           "mus/manual/"
sync_folder ~/pix/                  "pix"
sync_folder ~/prj/toshiro/          "prj/toshiro/"
sync_folder  ~/.local/bin/scripts/  "prj/df-backup/scripts/"
