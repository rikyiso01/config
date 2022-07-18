#!/usr/bin/env bash

set -e

cd "$(dirname $0)"

SYSTEM='/etc/nixos'
LOCAL="$HOME/.config/nixpkgs"
MONITORED_LOCALS="$LOCAL/home.nix"
MONITORED_SYSTEMS="$SYSTEM/configuration.nix"
OLD_LOCAL="$(cat $MONITORED_LOCALS)"
OLD_SYSTEM="$(cat $MONITORED_SYSTEMS)"

git stash
git -C "$LOCAL" pull
git stash pop || true
if [[ "$(cat $MONITORED_SYSTEMS)" != "$OLD_SYSTEMS" ]]
then
    sudo git -C "$SYSTEM" pull
    sudo nixos-rebuild switch
fi

dconf dump / | dconf2nix > "$LOCAL/dconf.nix"

if [[ "$(cat $MONITORED_LOCALS)" != "$OLD_LOCALS" ]]
then
    home-manager switch
fi
