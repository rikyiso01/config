#!/usr/bin/env bash

set -euo pipefail

apx init --nix
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
home-manager switch

ghc powertop.hs -odir /tmp/autotune -hidir /tmp/autotune -o "$HOME/.local/bin/autotune"
sudo chown root:root "$HOME/.local/bin/autotune"
sudo chmod u+s "$HOME/.local/bin/autotune"
