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
com.brave.Browser
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
rest.insomnia.Insomnia
org.ghidra_sre.Ghidra
org.wireshark.Wireshark
io.typora.Typora
org.octave.Octave
net.ankiweb.Anki
org.mapeditor.Tiled
org.raspberrypi.rpi-imager
io.dbeaver.DBeaverCommunity
com.obsproject.Studio
net.lutris.Lutris
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

flatpak override 'com.visualstudio.code' --user --env="PATH=$HOME/.local/bin:$HOME/.local/flatpak/:$HOME/.nix-profile/bin:/app/bin:/usr/bin:$HOME/.var/app/com.visualstudio.code/data/node_modules/bin"

flatpak override 'com.brave.Browser' --user --filesystem='/nix/store:ro'
flatpak override 'com.brave.Browser' --user --filesystem="$HOME/.local/flatpak:ro"
flatpak override 'com.brave.Browser' --user --env="PATH=$HOME/.local/flatpak:/app/bin:/usr/bin"

flatpak remote-add --user --if-not-exists launcher.moe 'https://gol.launcher.moe/gol.launcher.moe.flatpakrepo'
flatpak install --user --or-update -y launcher.moe 'com.gitlab.KRypt0n_.an-anime-game-launcher'

flatpak update -y