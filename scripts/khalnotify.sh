#!/bin/bash

function khal_interrogate ()
{
  khal_interrogate=`$HOME/vdirsyncer_env/bin/khal at $(date -d "$1" +%H:%M)`
}

# to retrieve the DBUS address
export $(egrep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -f "dbus-daemon --config-file")/environ)
if [ $num -gt "1" ]
then
    notify-send "Hitzorduak" "`task active | tail -n +3 | head -n -1`" 
    ogg123 /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga
fi
