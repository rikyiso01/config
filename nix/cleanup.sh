#!/usr/bin/env bash

set -euo pipefail

podman system prune --all --volumes --force
podman rmi --all --force
/bin/find ~/backup -type d -name ".direnv" -exec rm -r {} ';' || true
/bin/find ~/Work -type d -name ".direnv" -exec rm -r {} ';' || true
nix-collect-garbage --delete-old
nix-store --optimise
rm -r ~/Downloads/* || true
trash-empty -f
