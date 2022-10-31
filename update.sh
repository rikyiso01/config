#!/usr/bin/env bash

set -euo pipefail

LOCAL="$HOME/.config/nixpkgs"

git -C "$LOCAL" pull
home-manager switch

$LOCAL/flatpak.sh