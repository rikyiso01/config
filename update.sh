#!/usr/bin/env bash

set -euo pipefail
cd "$(dirname "$0")"

systemctl --failed
systemctl --user --failed
pacdiff

nix flake update
home-manager switch --flake .

flatpak update -y

sudo pacman -Syu

pacdiff
