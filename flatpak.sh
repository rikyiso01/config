#!/usr/bin/env bash

set -euo pipefail

fix()
{
    grep -v 'DBusActivatable=true' < "$HOME/.local/share/flatpak/exports/share/applications/$1.desktop" > "$HOME/.local/share/applications/$1.desktop"
    chmod +x "$HOME/.local/share/applications/$1.desktop"
}

add-wayland()
{
    if [[ "$2" == 'true' ]]
    then
        flags='--enable-features=WaylandWindowDecorations --ozone-platform-hint=auto'
    else
        flags='--enable-features=UseOzonePlatform --ozone-platform=wayland'
    fi
    sed "s/Exec=.*/& $flags/g" < "$HOME/.local/share/flatpak/exports/share/applications/$1.desktop" > "$HOME/.local/share/applications/$1.desktop"
    chmod +x "$HOME/.local/share/applications/$1.desktop"
}

flatpak remote-add --user --if-not-exists flathub 'https://flathub.org/repo/flathub.flatpakrepo'

flathub='
com.github.marktext.marktext
com.brave.Browser
com.google.AndroidStudio
com.github.tchx84.Flatseal
org.videolan.VLC
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
com.usebottles.bottles
org.gnome.GHex
org.audacityteam.Audacity
com.mattjakeman.ExtensionManager
flathub org.x.Warpinator
'

fix 'org.gnome.TextEditor'
fix 'org.gnome.Characters'
fix 'org.gnome.Logs'
fix 'org.gnome.Boxes'
fix 'ca.desrt.dconf-editor'
fix 'org.gnome.baobab'


if [ ! -d "$HOME/.local/share/fonts" ]
then
    ln -s "$HOME/.nix-profile/share/fonts" "$HOME/.local/share/fonts"
fi

flatpak install --user --or-update -y flathub $flathub

flatpak override 'com.visualstudio.code' --user --env="PATH=$HOME/.local/flatpak:$HOME/.local/bin:$HOME/.nix-profile/bin:/app/bin:/usr/bin:$HOME/.var/app/com.visualstudio.code/data/node_modules/bin"

flatpak override 'com.brave.Browser' --user --filesystem='/nix/store:ro'
flatpak override 'com.brave.Browser' --user --filesystem="$HOME/.local/flatpak:ro"
flatpak override 'com.brave.Browser' --user --filesystem="$HOME/.nix-profile/bin:ro"
flatpak override 'com.brave.Browser' --user --env="PATH=$HOME/.local/flatpak:/app/bin:/usr/bin"

flatpak override 'org.audacityteam.Audacity' --user --socket='wayland'
flatpak override 'org.raspberrypi.rpi-imager' --user --socket='wayland'
flatpak override 'net.ankiweb.Anki' --user --env='ANKI_WAYLAND=1'
add-wayland 'rest.insomnia.Insomnia' true
add-wayland 'io.typora.Typora' false
flatpak override 'com.visualstudio.code' --user --socket='wayland'
add-wayland 'com.visualstudio.code' true

flatpak override 'org.wireshark.Wireshark' --user --filesystem='home'


flatpak remote-add --user --if-not-exists flathub-beta 'https://flathub.org/beta-repo/flathub-beta.flatpakrepo'
flatpak install --user --or-update -y flathub-beta 'org.gimp.GIMP'


flatpak remote-add --user --if-not-exists launcher.moe 'https://gol.launcher.moe/gol.launcher.moe.flatpakrepo'
flatpak install --user --or-update -y launcher.moe 'com.gitlab.KRypt0n_.an-anime-game-launcher'

flatpak update -y