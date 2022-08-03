#!/usr/bin/env bash

set -e

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flathub="
com.github.marktext.marktext
org.libretro.RetroArch
com.brave.Browser
com.vscodium.codium
org.godotengine.Godot
com.google.AndroidStudio
com.github.tchx84.Flatseal
org.gnome.Evince
org.gnome.FileRoller
org.gnome.Shotwell
"

if [ ! -d "$HOME/.local/share/fonts" ]
then
    ln -s "$HOME/.nix-profile/share/fonts" "$HOME/.local/share/fonts"
fi

if [ ! -d "$HOME/.themes" ]
then
    ln -s "$HOME/.nix-profile/share/themes" "$HOME/.themes"
fi

flatpak install --or-update -y flathub $flathub

flatpak override com.vscodium.codium --user --env=PATH=/home/riky/.local/flatpak:/usr/bin:/app/bin

flatpak remote-add --if-not-exists launcher.moe https://gol.launcher.moe/gol.launcher.moe.flatpakrepo
flatpak install --or-update launcher.moe com.gitlab.KRypt0n_.an-anime-game-launcher
