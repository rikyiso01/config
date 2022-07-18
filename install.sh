#!/usr/bin/env bash

set -e

cd "$(dirname $0)"

sudo nix-channel --add 'https://github.com/NixOS/nixos-hardware/archive/master.tar.gz' nixos-hardware
sudo nix-channel --update

sudo cp * .* '/etc/nixos'

nix-channel --add 'https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz' home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

mkdir -p "$HOME/.config/nixpkgs"
cp * .* "$HOME/.config/nixpkgs"