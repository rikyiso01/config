#!/usr/bin/env bash

set -euo pipefail
cd "$(dirname "$0")"

git diff --quiet

systemctl --failed
systemctl --user --failed

podman pull docker.io/dovecot/dovecot:latest
flatpak update -y

nix flake update
home-manager switch --flake .

sudo -E pacdiff

sudo pacman -Syu
echo "Server = https://archive.archlinux.org/repos/$(date '+%Y/%m/%d')/\$repo/os/\$arch" > ./mirrorlist

sudo -E pacdiff

git commit -am 'update'
git push
