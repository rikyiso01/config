#!/usr/bin/env bash

set -euo pipefail

eval "$(ssh-agent -s)"
echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK;export SSH_AGENT_PID=$SSH_AGENT_PID" > "$HOME/.ssh/environment"
ssh-add "$HOME/.ssh/id_ed25519"

sudo tlp init start

if [[ $(cat '/sys/class/power_supply/BAT1/status') == 'Discharging' ]]
then
    rfkill block bluetooth
    brightnessctl -d intel_backlight set 15%
else
    rfkill unblock bluetooth
    sudo start-docker
fi
