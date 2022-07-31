#!/usr/bin/env bash

set -e

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flathub="
org.gnome.baobab
org.gnome.FileRoller
org.gnome.Characters
org.gnome.Evince
org.gnome.font-viewer
org.gnome.eog
org.gnome.Logs
com.github.marktext.marktext
org.libretro.RetroArch
org.gnome.TextEditor
com.brave.Browser
"

flatpak install --or-update flathub $flathub

flatpak remote-add --if-not-exists launcher.moe https://gol.launcher.moe/gol.launcher.moe.flatpakrepo
flatpak install --or-update launcher.moe com.gitlab.KRypt0n_.an-anime-game-launcher
