#!/usr/bin/env bash

set -euo pipefail

readonly FILE='/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode'

readonly status="$(cat "$FILE")"

if [[ $status = 1 ]]
then
    echo "Disabling conservative mode"
    sudo echo -n '0' | sudo tee "$FILE" > /dev/null
else
    echo "Enabling conservative mode"
    sudo echo -n '1' | sudo tee "$FILE" > /dev/null
fi
