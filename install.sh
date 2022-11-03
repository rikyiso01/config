#!/usr/bin/env bash

set -euo pipefail

sudo bash -c 'modprobe -r pcspkr && echo "blacklist pcspkr" >> /etc/modprobe.d/50-blacklist.conf'
sudo pamac remove --no-confirm firefox wget gnome-calculator gnome-calendar file-roller firefox-gnome-theme-maia gedit gparted gthumb gnome-user-docs gnome-logs lollypop gnome-system-monitor totem gnome-weather sushi evince manjaro-hello htop manjaro-settings-manager-notifier manjaro-application-utility manjaro-artwork gnome-shell-extensions
sudo pamac install --no-confirm docker flatpak gamemode nix tlp virtualbox xdg-desktop-portal-gnome virtualbox-host-dkms manjaro-settings-manager xdg-desktop-portal-wlr pipewire-media-session manjaro-pipewire
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
sudo bash -c 'echo "USB_EXCLUDE_BTUSB=1
CPU_ENERGY_PERF_POLICY_ON_AC=balance_performance
CPU_ENERGY_PERF_POLICY_ON_BAT=power
PCIE_ASPM_ON_AC=default
PCIE_ASPM_ON_BAT=powersupersave" >> /etc/tlp.conf'
ln -s "$HOME/.nix-profile/share/gnome-shell/extensions" "$HOME/.local/share/gnome-shell/extensions"