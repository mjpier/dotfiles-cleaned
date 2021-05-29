#!/usr/bin/sh

# this script autostarts on startup
# please be careful

# dwm status
# locker
~/.dwm/dwm-bar/dwm_bar.sh 2>/dev/null &
xautolock -time 10 -locker ~/.config/scripts/lock &

