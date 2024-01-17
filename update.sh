#!/usr/bin/env bash

set -euo pipefail
cd "$(dirname "$0")"

sudo -i nix upgrade-nix
nix flake update
home-manager switch --flake .

flatpak update -y

rpm-ostree upgrade
