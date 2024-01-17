#!/usr/bin/env bash

set -euo pipefail
cd "$(dirname "$0")"

curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

flatpak remote-delete --system fedora flathub
flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub -y org.freedesktop.Sdk//22.08 org.freedesktop.Platform//22.08 org.freedesktop.Sdk.Extension.openjdk11/x86_64/22.08

nix run nixpkgs#home-manager -- switch --flake . -b backup

sudo rpm-ostree --apply-live install libvirt libvirt-daemon-config-network libvirt-daemon-kvm qemu-kvm
sudo systemctl enable libvirtd.socket virtqemud.socket virtstoraged.socket virtnetworkd.socket

grep -E '^libvirt:' /usr/lib/group | sudo tee -a /etc/group
sudo usermod -aG libvirt $USER

secret-tool store --label='Keepass password' keepass password
