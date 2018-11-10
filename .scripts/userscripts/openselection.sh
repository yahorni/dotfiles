#!/bin/bash

echo "open -t $1 $QUTE_SELECTED_TEXT" >> "$QUTE_FIFO"
