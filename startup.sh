#!/usr/bin/env bash

set -euo pipefail

"$HOME/.nix-profile/bin/systemctl" start --user 'tlp'
"$HOME/.nix-profile/bin/systemctl" start --user 'thermald'
"$HOME/.nix-profile/bin/systemctl" start --user 'ssh'

if [[ $("$HOME/.nix-profile/bin/cat" '/sys/class/power_supply/BAT1/status') == 'Discharging' ]]; then
    "$HOME/.nix-profile/bin/rfkill" block 'bluetooth'
    "$HOME/.nix-profile/bin/brightnessctl" -d 'intel_backlight' set '15%'
else
    "$HOME/.nix-profile/bin/rfkill" unblock 'bluetooth'
    "$HOME/.nix-profile/bin/systemctl" start --user 'docker'
    /usr/bin/sudo /home/riky/.nix-profile/bin/systemctl start 'avahi-daemon'
    /usr/bin/sudo /home/riky/.nix-profile/bin/systemctl start 'cups'
fi
