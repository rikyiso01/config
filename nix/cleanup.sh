#!/usr/bin/env bash

set -euo pipefail

podman system prune --all --volumes --force
podman rmi --all --force
nix-collect-garbage --delete-old
nix-store --optimise
