#!/bin/bash

message=$(ytloader -f $1 $QUTE_URL)
[[ "$?" -eq "0" ]] && echo ":message-info 'File \"$QUTE_TITLE\" successfully loaded'" >>$QUTE_FIFO && exit
echo ":message-info 'Error occured: $message'"
