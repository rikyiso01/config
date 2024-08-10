#!/usr/bin/env bash

set -euo pipefail

podman system prune --all --volumes --force
podman rmi --all --force
nix-store --gc
nix-store --optimise
