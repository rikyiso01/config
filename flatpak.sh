#!/usr/bin/env bash

set -e

fix()
{
    grep -v 'DBusActivatable=true' < "$HOME/.local/share/flatpak/exports/share/applications/$1.desktop" > "$HOME/.local/share/applications/$1.desktop"
}

flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flathub='
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
org.gnome.baobab
'

if [ ! -d "$HOME/.local/share/fonts" ]
then
    ln -s "$HOME/.nix-profile/share/fonts" "$HOME/.local/share/fonts"
fi

if [ ! -d "$HOME/.themes" ]
then
    ln -s "$HOME/.nix-profile/share/themes" "$HOME/.themes"
fi

flatpak install --user --or-update -y flathub $flathub

fix 'org.gnome.baobab'

flatpak override com.vscodium.codium --user --env=PATH=$HOME/.local/flatpak:/usr/bin:/app/bin
flatpak override --user --filesystem=$HOME/.themes:ro

flatpak remote-add --user --if-not-exists launcher.moe https://gol.launcher.moe/gol.launcher.moe.flatpakrepo
flatpak install --user --or-update launcher.moe com.gitlab.KRypt0n_.an-anime-game-launcher
