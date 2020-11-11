#!/bin/sh

lockfile="/tmp/monitor-input"
if [ "plugged in" != "$(< $lockfile)" ]; then
    echo "plugged in" > $lockfile
    ddcutil setvcp --sn=CFV9N6B80KEL 60 x12
    ddcutil setvcp --sn=CFV9N7BO103L 60 x12
    ddcutil setvcp --sn=CFV9N6B8058L 60 x12
fi
