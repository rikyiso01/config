#!/usr/bin/env bash

set -eou pipefail

cd "$(dirname "$0")"

nix run -- nixpkgs#home-manager switch --flake . -b backup
sudo systemctl enable greetd
passwd
# secret-tool store --label='Keepass password' keepass password
# rclone config
