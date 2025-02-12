#!/usr/bin/env bash

set -eou pipefail

cd "$(dirname "$0")"

sudo pacman -S --noconfirm --needed base linux linux-firmware sof-firmware networkmanager networkmanager-openvpn zsh sudo nix greetd greetd-tuigreet hyprland kitty swaylock intel-ucode reflector intel-media-driver util-linux flatpak xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-hyprland polkit-gnome pipewire wireplumber podman wofi pipewire-jack pipewire-alsa pipewire-pulse pipewire-audio qemu-desktop vulkan-intel gnome-keyring power-profiles-daemon libvirt virt-manager bluez bluez-utils nautilus pacman-contrib

sudo systemctl enable --now nix-daemon
sudo systemctl enable --now systemd-resolved
sudo systemctl enable --now systemd-timesyncd

sudo ln -sf ../run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

sudo usermod -aG nix-users "$USER"


mkdir -p "$HOME/.config/nix"

echo 'experimental-features = nix-command flakes' > "$HOME/.config/nix/nix.conf" || true


# sudo -Eu riky nix run -- nixpkgs#home-manager switch --flake . -b backup
#
sudo flatpak remote-delete --system flathub || true

if [[ ! -f /swapfile ]]
then
    sudo mkswap -U clear --size 16G --file /swapfile
fi

if ! grep '/swap' /etc/fstab
then
    echo '/swapfile none swap defaults 0 0' | sudo tee -a /etc/fstab
fi

if ! grep '/intel-ucode.img' /boot/loader/entries/arch.conf
then
    sudo sed -i '3iinitrd  /intel-ucode.img' /boot/loader/entries/arch.conf
fi
#
# sudo systemctl enable greetd

