#!/usr/bin/env bash

set -euo pipefail

zip -vry './backup.zip' "$HOME/.var/app/net.lutris.Lutris/data" "$HOME/.var/app/net.lutris.Lutris/config" "$HOME/.var/app/org.libretro.RetroArch/config" "$HOME/Games"
