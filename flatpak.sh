#!/usr/bin/env bash

set -euo pipefail

flatpak remote-add --user --if-not-exists flathub 'https://flathub.org/repo/flathub.flatpakrepo'

flathub='
com.brave.Browser
com.google.AndroidStudio
com.github.tchx84.Flatseal
org.videolan.VLC
com.visualstudio.code
rest.insomnia.Insomnia
org.ghidra_sre.Ghidra
org.wireshark.Wireshark
net.ankiweb.Anki
org.mapeditor.Tiled
org.raspberrypi.rpi-imager
io.dbeaver.DBeaverCommunity
com.obsproject.Studio
org.gnome.Evince
org.gnome.FileRoller
org.gnome.Shotwell
org.gnome.seahorse.Application
org.gnome.PowerStats
org.gnome.Boxes
com.usebottles.bottles
org.gnome.GHex
org.audacityteam.Audacity
com.mattjakeman.ExtensionManager
org.localsend.localsend_app
'

flatpak install --user --or-update -y flathub $flathub

flatpak remote-add --user --if-not-exists flathub-beta 'https://flathub.org/beta-repo/flathub-beta.flatpakrepo'
flatpak install --user --or-update -y flathub-beta 'org.gimp.GIMP'

flatpak update -y