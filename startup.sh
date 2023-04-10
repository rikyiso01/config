#!/usr/bin/env bash

set -euo pipefail

systemctl start --user 'ssh-agent'

if [[ $(/usr/bin/cat '/sys/class/power_supply/BAT1/status') == 'Discharging' ]]; then
    rfkill block 'bluetooth'
    brightnessctl -d 'intel_backlight' set '15%'
else
    rfkill unblock 'bluetooth'
fi
