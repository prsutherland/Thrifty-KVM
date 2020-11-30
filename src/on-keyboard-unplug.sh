#!/bin/sh

lockfile="/tmp/monitor-input"
if [ "unplugged" != "$(< $lockfile)" ]; then
    echo "unplugged" > $lockfile
    ddcutil setvcp --sn=[SERIAL] [FEATURE] x[VALUE]
    ddcutil setvcp --sn=[SERIAL] [FEATURE] x[VALUE]
    ddcutil setvcp --sn=[SERIAL] [FEATURE] x[VALUE]
fi
