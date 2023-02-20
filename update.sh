#!/usr/bin/env bash

set -euo pipefail

LOCAL="$HOME/.config/nixpkgs"

git -C "$LOCAL" pull
sudo pamac update --no-confirm
nix-channel --update
home-manager switch

$LOCAL/flatpak.sh