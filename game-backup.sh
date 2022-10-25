#!/usr/bin/env bash

set -euo pipefail

rm -rf '/tmp/backup'
mkdir -p '/tmp/backup'

mkdir '/tmp/backup/net.lutris.Lutris'
cp -r "$HOME/.var/app/net.lutris.Lutris/data" '/tmp/backup/net.lutris.Lutris'
cp -r "$HOME/.var/app/net.lutris.Lutris/config" '/tmp/backup/net.lutris.Lutris'

mkdir '/tmp/backup/org.libretro.RetroArch'
cp -r "$HOME/.var/app/org.libretro.RetroArch/config" '/tmp/backup/org.libretro.RetroArch'

mkdir '/tmp/backup/Games'
cp -r "$HOME/Games" '/tmp/backup/Games'

zip -ry './backup.zip' '/tmp/backup'
rm -rf '/tmp/backup'