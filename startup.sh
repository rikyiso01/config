#!/usr/bin/env bash

set -euo pipefail

if [[ $(/usr/bin/cat '/sys/class/power_supply/BAT1/status') == 'Discharging' ]]; then
    rfkill block 'bluetooth'
    brightnessctl -d 'intel_backlight' set '15%'
    (exec -c powerprofilesctl set power-saver)
else
    rfkill unblock 'bluetooth'
    (exec -c powerprofilesctl set balanced)
fi
