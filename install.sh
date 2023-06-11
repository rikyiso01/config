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

nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
home-manager switch -f home.nix -b backup

ghc powertop.hs -odir /tmp/autotune -hidir /tmp/autotune -o "$HOME/.local/bin/autotune"
sudo chown root:root "$HOME/.local/bin/autotune"
sudo chmod u+s "$HOME/.local/bin/autotune"

flatpak remote-delete --system --force flathub
flatpak remote-delete --system --force fedora
