#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")"

if [ -f /nix/nix-installer ]; then
    /nix/nix-installer uninstall --no-confirm
fi
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm

. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

rm -rf /var/home/riky/.local/state/nix/profiles/home-manager* /var/home/riky/.local/state/home-manager/gcroots/current-home /var/home/riky/.config/user-dirs.dirs.backup

nix run nixpkgs#home-manager -- switch --flake . -b backup
