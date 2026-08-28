#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")"

udisksctl mount -b /dev/sda1 || true
ssh homeassistant.riccardoisola.dev sudo mkdir -p /mnt/harddisk
ssh homeassistant.riccardoisola.dev 'mountpoint -q /mnt/harddisk || sudo mount /dev/sda1 /mnt/harddisk'

bash backup-sync.sh /run/media/riky/90304ff6-a81a-4307-be0f-ab65846845ea/backup 'homeassistant.riccardoisola.dev:/mnt/harddisk'

ssh homeassistant.riccardoisola.dev sudo umount /mnt/harddisk
ssh homeassistant.riccardoisola.dev sudo rmdir /mnt/harddisk
udisksctl unmount -b /dev/sda1
