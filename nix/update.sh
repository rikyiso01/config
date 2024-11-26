#!/usr/bin/env bash

set -euo pipefail
cd "$(dirname "$0")"

systemctl --failed
systemctl --user --failed

flatpak update -y

nix flake update
home-manager switch --flake .

sudo -E pacdiff

sudo pacman -Syu

sudo -E pacdiff
