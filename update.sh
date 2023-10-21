#!/usr/bin/env bash

set -euo pipefail
cd "$(dirname "$0")"

nix profile upgrade 0
nix flake update
home-manager switch --flake .

flatpak update -y

sudo rpm-ostree upgrade
