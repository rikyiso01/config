#!/usr/bin/env bash

set -euo pipefail
shopt -s globstar


while ! getent hosts www.google.com
do
    sleep 5
done

cat ~/backup/Contacts/**/*.vcf > ~/backup/phone/Drive/contacts.vcf

RCLONE_PASSWORD_COMMAND="$HOME/.local/bin/password show -a Password rclone" "$HOME/.nix-profile/bin/rclone" --config ~/backup/rclone.conf copy --update ~/backup/phone/Drive drive:Syncthing

