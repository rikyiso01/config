#!/usr/bin/env bash

set -euo pipefail

if [[ -f "$1" ]]
then
    mv "$1" "$(dirname "$1")/$(date -r "$1" '+%Y-%m-%d')-$(basename "$1")"
fi

cp "$(dirname "$0")/restore.sh" "$(dirname "$1")"/restore.sh
cp "$(dirname "$0")/backup-sync.sh" "$(dirname "$1")"/backup-sync.sh

tar -C ~ -c backup | tqdm --unit-scale --bytes --total "$(du -sb ~/backup | awk '{print $1}')" | openssl aes-256-cbc -pbkdf2 -kfile ~/backup/backup-pw -out "$1"
