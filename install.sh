#!/usr/bin/env bash

set -euo pipefail
cd "$(dirname "$0")"

sudo setenforce Permissive
sudo sed -i 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config
sudo mkdir /var/lib/nix
sudo chown "$USER:$USER" /var/lib/nix

echo "[Unit]
Description=Enable mount points in / for ostree
ConditionPathExists=!%f
DefaultDependencies=no
Requires=local-fs-pre.target
After=local-fs-pre.target

[Service]
Type=oneshot
ExecStartPre=chattr -i /
ExecStart=mkdir -p '%f'
ExecStopPost=chattr +i /" | sudo tee /etc/systemd/system/mkdir-rootfs@.service

echo "[Unit]
Description=Nix Package Manager
DefaultDependencies=no
After=mkdir-rootfs@nix.service
Wants=mkdir-rootfs@nix.service
Before=sockets.target
After=ostree-remount.service
BindsTo=var.mount

[Mount]
What=/var/lib/nix
Where=/nix
Options=bind
Type=none

[Install]
WantedBy=local-fs.target" | sudo tee /etc/systemd/system/nix.mount

sudo systemctl daemon-reload
sudo systemctl enable nix.mount
sudo systemctl start nix.mount

sh <(curl -L https://nixos.org/nix/install) --no-daemon

export PATH=~/.nix-profile/bin:$PATH

flatpak install flathub -y org.freedesktop.Sdk//22.08 org.freedesktop.Platform//22.08

nix-channel --remove nixpkgs
nix --extra-experimental-features nix-command --extra-experimental-features flakes profile install nixpkgs#nix --priority 4
nix --extra-experimental-features nix-command --extra-experimental-features flakes profile remove 0
nix --extra-experimental-features nix-command --extra-experimental-features flakes run nixpkgs#home-manager -- switch --flake . -b backup
