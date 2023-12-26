#!/usr/bin/env bash

set -euo pipefail

podman system prune -a --volumes -f
nix-store --gc
nix-store --optimise
