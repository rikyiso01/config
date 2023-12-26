#!/usr/bin/env bash

set -euo pipefail
cd "$(dirname "$0")"

nix profile upgrade 0
nix flake update
nix-channel --update
home-manager switch --flake .

flatpak update -y

rpm-ostree upgrade
