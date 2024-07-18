#!/bin/sh

# This script is just workaround for xdg desktop entries, because:
# 1. Desktop files can't work with environment
# 2. Quotes completely broken, I haven't found any way to use them
# 3. I have spent too much time already trying to do it in a desktop file

# Usage:   env-wrapper COMMAND arguments...
# Example: env-wrapper EDITOR ~/.profile

cmd="$1"
shift
$(eval "echo \"\$$cmd\"") "$@"
