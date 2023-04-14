#!/usr/bin/env bash

set -euo pipefail

apx init --nix
apx install --nix home-manager
home-manager switch
