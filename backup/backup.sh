#!/usr/bin/env bash

set -euo pipefail

cp "$(dirname "$0")/restore.sh" "$RESTIC_REPOSITORY"/restore.sh

restic "$@" forget --keep-last 3 --prune
restic "$@" check
restic "$@" backup ~/backup

