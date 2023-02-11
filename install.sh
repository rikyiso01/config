#!/usr/bin/env bash

set -euo pipefail

sudo bash -c 'modprobe -r pcspkr && echo "blacklist pcspkr" >> /etc/modprobe.d/50-blacklist.conf'
sudo pamac remove --no-confirm firefox wget gnome-calculator gnome-calendar file-roller firefox-gnome-theme-maia gedit gparted gthumb gnome-user-docs gnome-logs lollypop gnome-system-monitor totem gnome-weather sushi evince manjaro-hello htop manjaro-settings-manager-notifier manjaro-application-utility manjaro-artwork gnome-shell-extensions nano-syntax-highlighting vi powertop manjaro-zsh-config
sudo pamac install --no-confirm flatpak nix xdg-desktop-portal-gnome manjaro-settings-manager xdg-desktop-portal-wlr pipewire-media-session manjaro-pipewire pkgconf manjaro-printer system-config-printer
sudo gpasswd -a "$USER" sys
sudo gpasswd -a "$USER" nix-users
sudo systemctl enable --now nix-daemon
sudo systemctl enable --now cups.service
sudo systemctl enable --now cups.socket
sudo systemctl enable --now cups.path
sudo systemctl enable --now avahi-daemon.service
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
rm -rf "$HOME/.config/nixpkgs" "$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.bash_profile"
git clone 'https://gist.github.com/bfe678d14ce98713dd5242b5457c73b1.git' "$HOME/.config/nixpkgs"
home-manager switch
sudo bash -c 'echo "USB_EXCLUDE_BTUSB=1
CPU_ENERGY_PERF_POLICY_ON_AC=balance_performance
CPU_ENERGY_PERF_POLICY_ON_BAT=power
PCIE_ASPM_ON_AC=default
PCIE_ASPM_ON_BAT=powersupersave" >> /etc/tlp.conf'
mkdir -p "$HOME/Games/Minecraft/tlauncher"
ln -s "$HOME/Games/Minecraft/tlauncher" "$HOME/.tlauncher"
ln -s "$HOME/.nix-profile/share/gnome-shell/extensions" "$HOME/.local/share/gnome-shell/extensions"
systemctl --user mask tracker-extract-3.service tracker-miner-fs-3.service tracker-miner-rss-3.service tracker-writeback-3.service tracker-xdg-portal-3.service tracker-miner-fs-control-3.service
tracker3 reset -s -r
sudo bash -c "echo $USER ALL=(ALL) NOPASSWD:$HOME/.nix-profile/bin/tlp init start, $HOME/.local/bin/start-docker >> /etc/sudoers"
poetry config virtualenvs.in-project true
sudo usermod --shell /bin/bash riky
# pagedjs
mkdir "$HOME/.pnpm"
pnpm install -g pagedjs-cli