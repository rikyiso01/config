#!/usr/bin/env bash

set -euo pipefail

REMOVE='
bibata-cursor-theme
evince
file-roller
firefox
gedit
gnome-calculator
gnome-calendar
gnome-disk-utility
gnome-logs
gnome-shell-extensions
gnome-shell-maia
gnome-system-monitor
gnome-tour
gnome-tweaks
gnome-user-docs
gnome-weather
gthumb
htop
kvantum-manjaro
lollypop
man-db
man-pages
manjaro-hello
manjaro-ranger-settings
manjaro-zsh-config
nano-syntax-highlighting
plymouth-theme-manjaro
sushi
totem
vi
wget
which
'
sudo bash -c 'echo "blacklist pcspkr" >> /etc/modprobe.d/50-blacklist.conf'
sudo pacman -Rs --noconfirm $REMOVE
sudo pacman -S --noconfirm flatpak nix xdg-desktop-portal-gnome manjaro-settings-manager xdg-desktop-portal-wlr pipewire-media-session manjaro-pipewire cups git
sudo gpasswd -a "$USER" sys
sudo gpasswd -a "$USER" nix-users
sudo systemctl enable --now nix-daemon
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
rm -f "$HOME/.config/home-manager" "$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.config/user-dirs.dirs" "$HOME/.config/gtk-3.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini" "$HOME/.config/mimeapps.list" "$HOME/.local/share/applications/mimeapps.list"
git clone 'https://gist.github.com/bfe678d14ce98713dd5242b5457c73b1.git' "$HOME/.config/home-manager"
"$HOME/.nix-profile/bin/home-manager" switch
sudo ln -s "$HOME/.config/tlp.conf" /etc/tlp.conf
sudo rm -f /etc/avahi/avahi-daemon.conf
sudo ln -s "$HOME/.config/avahi-daemon.conf" /etc/avahi/avahi-daemon.conf
sudo bash -c "echo $USER ALL=(ALL) NOPASSWD:$HOME/.nix-profile/bin/tlp, $HOME/.nix-profile/bin/dockerd -H unix\:///var/run/docker.sock, $HOME/.nix-profile/bin/systemctl start cups, $HOME/.nix-profile/bin/systemctl start avahi-daemon" >>/etc/sudoers
sudo usermod --shell /bin/bash "$USER"
