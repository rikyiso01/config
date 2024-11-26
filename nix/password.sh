#!/usr/bin/env bash

set -euo pipefail

action="$1"
shift

secret-tool lookup keepass password | flatpak run --command=keepassxc-cli org.keepassxc.KeePassXC "$action" ~/backup/Syncthing/keepass.kdbx "$@"
