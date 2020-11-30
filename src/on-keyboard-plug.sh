#!/bin/sh

lockfile="/tmp/monitor-input"
if [ "plugged in" != "$(< $lockfile)" ]; then
    echo "plugged in" > $lockfile
    ddcutil setvcp --sn=[SERIAL] [FEATURE] x[VALUE]
    ddcutil setvcp --sn=[SERIAL] [FEATURE] x[VALUE]
    ddcutil setvcp --sn=[SERIAL] [FEATURE] x[VALUE]
fi
