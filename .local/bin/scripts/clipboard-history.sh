#!/bin/bash
greenclip print | sed '/^$/d' | dmenu -i -l 10 | xargs -r -d'\n' -I '{}' greenclip print '{}'
