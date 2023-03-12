#!/usr/bin/env bash

set -euo pipefail

sudo bash -c 'modprobe -r pcspkr && echo "blacklist pcspkr" >> /etc/modprobe.d/50-blacklist.conf'
sudo pamac remove --no-confirm firefox wget gnome-calculator gnome-calendar file-roller firefox-gnome-theme-maia gedit gparted gthumb gnome-user-docs gnome-logs lollypop gnome-system-monitor totem gnome-weather sushi evince manjaro-hello htop manjaro-settings-manager-notifier manjaro-application-utility manjaro-artwork gnome-shell-extensions nano-syntax-highlighting vi powertop manjaro-zsh-config man-pages man-db which gnome-disk-utility
sudo pamac install --no-confirm flatpak nix xdg-desktop-portal-gnome manjaro-settings-manager xdg-desktop-portal-wlr pipewire-media-session manjaro-pipewire cups
sudo gpasswd -a "$USER" sys
sudo gpasswd -a "$USER" nix-users
sudo systemctl enable --now nix-daemon
sudo systemctl enable --now avahi-daemon.service
sudo systemctl enable --now cups
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
rm -rf "$HOME/.config/nixpkgs" "$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.config/user-dirs.dirs" "$HOME/.config/gtk-3.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini" "$HOME/.config/mimeapps.list" "$HOME/.local/share/applications/mimeapps.list"
git clone 'https://gist.github.com/bfe678d14ce98713dd5242b5457c73b1.git' "$HOME/.config/nixpkgs"
home-manager switch
sudo ln -s "$HOME/.config/tlp.conf" /etc/tlp.conf
sudo ln -s "$HOME/.config/avahi-daemon.conf" /etc/avahi/avahi-daemon.conf
sudo bash -c "echo $USER ALL=(ALL) NOPASSWD:$HOME/.nix-profile/bin/tlp, $HOME/.nix-profile/bin/dockerd -H unix\:///var/run/docker.sock, $HOME/.nix-profile/bin/cupsd -l >> /etc/sudoers"
sudo usermod --shell /bin/bash riky