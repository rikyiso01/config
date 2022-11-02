#!/usr/bin/env bash

set -euo pipefail

sudo bash -c 'modprobe -r pcspkr && echo "blacklist pcspkr" >> /etc/modprobe.d/50-blacklist.conf'
sudo pamac remove firefox wget gnome-calculator gnome-calendar file-roller firefox-gnome-theme-maia gedit gparted gthumb gnome-user-docs gnome-logs lollypop gnome-system-monitor totem gnome-weather sushi evince manjaro-hello htop manjaro-settings-manager-notifier
sudo pamac install docker flatpak gamemode nix tlp virtualbox xdg-desktop-portal-gnome virtualbox-host-dkms manjaro-settings-manager
sudo usermod -aG nix-users "$USER"
sudo systemctl enable nix-daemon
sudo systemctl start nix-daemon
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
rm -rf "$HOME/.config/nixpkgs" "$HOME/.zshrc"
git clone 'https://gist.github.com/bfe678d14ce98713dd5242b5457c73b1.git' "$HOME/.config/nixpkgs"
home-manager switch
sudo bash -c 'echo USB_EXCLUDE_BTUSB=1 >> /etc/tlp.conf'
