#!/usr/bin/env bash

set -euo pipefail

if [[ -d ~/backup ]]
then
    mv ~/backup ~/backup-old
fi

openssl aes-256-cbc -pbkdf2 -d -in "$1" | tqdm --unit-scale --bytes --total "$(du -sb "$1" | awk '{print $1}')" | tar -C ~ -x
