#!/usr/bin/env bash

set -euo pipefail

echo "Monitoring battery level"
while true; do
  bat_lvl="$(cat /sys/class/power_supply/BAT0/capacity)"
  status="$(cat /sys/class/power_supply/BAT0/status)"
  if [[ "$bat_lvl" < "$1" && "$status" != "Charging" ]]; then
    notify-send --urgency=CRITICAL "$2"
    echo "Sent notification"
    sleep 1200
  else
    sleep 120
  fi
done
