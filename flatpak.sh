#!/usr/bin/env bash

set -euo pipefail

flatpak remote-add --user --if-not-exists flathub 'https://flathub.org/repo/flathub.flatpakrepo'

flathub='
com.github.marktext.marktext
com.brave.Browser
com.google.AndroidStudio
com.github.tchx84.Flatseal
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
org.libretro.RetroArch
org.gnome.Evince
org.gnome.FileRoller
org.gnome.Shotwell
org.gnome.baobab
org.gnome.TextEditor
org.gnome.seahorse.Application
org.gnome.Characters
org.gnome.Logs
org.gnome.dfeet
ca.desrt.dconf-editor
org.gnome.PowerStats
org.gnome.Boxes
'

if [ ! -d "$HOME/.local/share/fonts" ]
then
    ln -s "$HOME/.nix-profile/share/fonts" "$HOME/.local/share/fonts"
fi

flatpak install --user --or-update -y flathub $flathub

flatpak override 'com.visualstudio.code' --user --env="PATH=$HOME/.local/flatpak:$HOME/.local/bin:$HOME/.nix-profile/bin:/app/bin:/usr/bin:$HOME/.var/app/com.visualstudio.code/data/node_modules/bin"

flatpak override 'com.brave.Browser' --user --filesystem='/nix/store:ro'
flatpak override 'com.brave.Browser' --user --filesystem="$HOME/.local/flatpak:ro"
flatpak override 'com.brave.Browser' --user --env="PATH=$HOME/.local/flatpak:/app/bin:/usr/bin"

flatpak override 'org.wireshark.Wireshark' --user --filesystem='home'

flatpak remote-add --user --if-not-exists launcher.moe 'https://gol.launcher.moe/gol.launcher.moe.flatpakrepo'
flatpak install --user --or-update -y launcher.moe 'com.gitlab.KRypt0n_.an-anime-game-launcher'

flatpak update -y