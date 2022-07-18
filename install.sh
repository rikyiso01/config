#!/usr/bin/env bash

set -e

cd "$(dirname $0)"

sudo nix-channel --add 'https://github.com/NixOS/nixos-hardware/archive/master.tar.gz' nixos-hardware
sudo nix-channel --update

sudo cp -rf * .git '/etc/nixos'

nix-channel --add 'https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz' home-manager
nix-channel --update
export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}
nix-shell '<home-manager>' -A install

mkdir -p "$HOME/.config/nixpkgs"
cp -rf * .git "$HOME/.config/nixpkgs"

sudo nixos-rebuild switch
home-manager switch