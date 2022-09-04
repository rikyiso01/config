#!/usr/bin/env bash

set -euo pipefail

fix()
{
    grep -v 'DBusActivatable=true' < "$HOME/.local/share/flatpak/exports/share/applications/$1.desktop" > "$HOME/.local/share/applications/$1.desktop"
    chmod +x "$HOME/.local/share/applications/$1.desktop"
}

add-wayland()
{
    sed 's/Exec=.*/& --enable-features=UseOzonePlatform --ozone-platform=wayland/g' < "$HOME/.local/share/flatpak/exports/share/applications/$1.desktop" > "$HOME/.local/share/applications/$1.desktop"
    chmod +x "$HOME/.local/share/applications/$1.desktop"
}

flatpak remote-add --user --if-not-exists flathub 'https://flathub.org/repo/flathub.flatpakrepo'

flathub='
com.github.marktext.marktext
org.libretro.RetroArch
com.brave.Browser
org.godotengine.Godot
com.google.AndroidStudio
com.github.tchx84.Flatseal
org.gnome.Evince
org.gnome.FileRoller
org.gnome.Shotwell
org.gnome.baobab
org.gnome.TextEditor
org.gnome.seahorse.Application
org.gnome.Characters
org.gnome.Logs
com.github.tchx84.Flatseal
org.gnome.dfeet
org.videolan.VLC
org.gimp.GIMP
com.visualstudio.code
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
fix 'org.gnome.FileRoller'
fix 'org.gnome.TextEditor'
fix 'org.gnome.seahorse.Application'
fix 'org.gnome.Characters'
fix 'org.gnome.Logs'

flatpak override --user --filesystem='~/.themes:ro'



flatpak override 'com.visualstudio.code' --user --env="PATH=$HOME/.local/flatpak:/app/bin:/usr/bin:$HOME/.var/app/com.visualstudio.code/data/node_modules/bin"


flatpak override 'com.brave.Browser' --user --filesystem='~/.local/flatpak:ro'
flatpak override 'com.brave.Browser' --user --filesystem='/nix/store:ro'
flatpak override 'com.brave.Browser' --user --talk-name='org.freedesktop.Flatpak'

flatpak remote-add --user --if-not-exists launcher.moe 'https://gol.launcher.moe/gol.launcher.moe.flatpakrepo'
flatpak install --user --or-update launcher.moe 'com.gitlab.KRypt0n_.an-anime-game-launcher'

flatpak remote-add --user --if-not-exists flathub-beta 'https://flathub.org/beta-repo/flathub-beta.flatpakrepo'
flatpak install --user --or-update flathub-beta 'net.lutris.Lutris'

flatpak update