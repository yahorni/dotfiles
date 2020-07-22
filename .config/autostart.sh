#!/bin/sh

pgrep mpd || mpd &
acpi_volume.sh &
