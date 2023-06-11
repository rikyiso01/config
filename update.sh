#!/usr/bin/env bash

set -euo pipefail
cd "$(dirname "$0")"

nix-channel --update
home-manager switch -f home.nix

flatpak update -y
