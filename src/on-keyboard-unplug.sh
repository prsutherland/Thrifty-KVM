#!/bin/sh

lockfile="/tmp/monitor-input"
if [ "unplugged" != "$(< $lockfile)" ]; then
    echo "unplugged" > $lockfile
    ddcutil setvcp --sn=CFV9N6B80KEL 60 x0f
    ddcutil setvcp --sn=CFV9N7BO103L 60 x0f
    ddcutil setvcp --sn=CFV9N6B8058L 60 x10
fi
