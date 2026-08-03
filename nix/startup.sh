#!/usr/bin/env bash

set -euo pipefail

if [[ $(/usr/bin/cat '/sys/class/power_supply/BAT0/status') == 'Discharging' ]]; then
    noctalia msg brightness-set '15%'
    noctalia msg power-set power-saver
else
    noctalia msg power-set balanced
fi

noctalia msg bluetooth-disable
