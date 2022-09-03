#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname $0)"

dconf dump / | dconf2nix > 'dconf.nix'

git commit -am 'update dconf.nix'
git push

git -C "$HOME/.config/nixpkgs" stash
git -C "$HOME/.config/nixpkgs" pull
git -C "$HOME/.config/nixpkgs" stash drop || true