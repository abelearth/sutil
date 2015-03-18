#!/bin/bash

#set -x

REMOTE_MACHINE=windy@192.168.1.2:/home/windy

if [ "X$1" = "X-i" ]; then
    if [ -f $2 ]; then
        SOURCE=$2
    else
        SOURCE=""
    fi
    DEST=$REMOTE_MACHINE/$3
else
    SOURCE=$REMOTE_MACHINE/$1
    if [ -d $2 ]; then
        DEST=$2
    else
        DEST=""
    fi
fi

if [ -n "$SOURCE" -a -n "$DEST" ]; then
    rsync -avz -e ssh "$SOURCE" "$DEST"
else
    echo "Parameters error!"
fi
