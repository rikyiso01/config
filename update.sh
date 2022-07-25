#!/usr/bin/env bash

set -e

cd "$(dirname $0)"

SYSTEM='/etc/nixos'
LOCAL="$HOME/.config/nixpkgs"
MONITORED_LOCALS="$LOCAL/home.nix $LOCAL/chromedriver.nix"
MONITORED_SYSTEMS="$LOCAL/configuration.nix"
OLD_LOCALS="$(cat $MONITORED_LOCALS)"
OLD_SYSTEMS="$(cat $MONITORED_SYSTEMS)"

git -C "$LOCAL" stash -q
git -C "$LOCAL" pull
git -C "$LOCAL" stash pop -q || true
if [[ "$(cat $MONITORED_SYSTEMS)" != "$OLD_SYSTEMS" ]]
then
    sudo git -C "$SYSTEM" pull
    sudo nixos-rebuild switch
fi

dconf dump / | python -c 'from sys import stdin;print(stdin.read().replace("\\n","").replace("\\\\",""),end="")' | dconf2nix > "$LOCAL/dconf.nix"

if [[ "$(cat $MONITORED_LOCALS)" != "$OLD_LOCALS" ]]
then
    home-manager switch
fi
