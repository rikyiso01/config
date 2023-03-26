#!/usr/bin/env bash

set -euo pipefail

LOCAL="$HOME/.config/home-manager"

git -C "$LOCAL" pull
nix-channel --update
home-manager switch

flatpak update -y
