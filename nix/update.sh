#!/usr/bin/env bash

set -euo pipefail
cd "$(dirname "$0")"

systemctl --failed
systemctl --user --failed

nix flake update
home-manager switch --flake .

flatpak update -y

pacdiff -s

sudo pacman -Syu

pacdiff -s
