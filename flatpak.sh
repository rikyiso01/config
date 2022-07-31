#!/usr/bin/env bash

set -e

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flathub="
com.github.marktext.marktext
org.libretro.RetroArch
com.brave.Browser
"

flatpak install --or-update -y flathub $flathub

flatpak remote-add --if-not-exists launcher.moe https://gol.launcher.moe/gol.launcher.moe.flatpakrepo
flatpak install --or-update launcher.moe com.gitlab.KRypt0n_.an-anime-game-launcher
