#!/usr/bin/env bash

set -euo pipefail

from="$1"
to="$2"
shift
shift

rsync -gloptruv --info=progress2 "$from" "$to"

restic -r "$from" "$@" forget --keep-last 20 --prune
restic -r "sftp:$to/backup" "$@" check
restic -r "sftp:$to/backup" "$@" forget --keep-last 50 --prune
restic -r "sftp:$to/backup" "$@" repair index
restic -r "sftp:$to/backup" "$@" check
