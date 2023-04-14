#!/usr/bin/env bash

set -euo pipefail

docker system prune -a --volumes -f
nix-store --gc
nix-store --optimise
