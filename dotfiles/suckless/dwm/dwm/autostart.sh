#!/usr/bin/sh

# this script autostarts on startup
# please be careful

# wallpaper
# dwm status
# locker
wallpaper="/home/ari/Pictures/wallpaper.jpg"
feh --bg-fill $wallpaper &
~/.dwm/dwm-bar/dwm_bar.sh 2>/dev/null &
xautolock -time 10 -locker ~/.config/scripts/lock &

