#!/usr/bin/env bash

set -euo pipefail
cd "$(dirname "$0")"

systemctl --failed
systemctl --user --failed

flatpak update -y

nix flake update
home-manager switch --flake .

pacdiff -s

sudo pacman -Syu

pacdiff -s
