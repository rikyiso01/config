#!/usr/bin/env bash

set -euo pipefail

rsync -gloptruv --info=progress2 "$1" "$2"

restic -r "$2" "$@" forget --keep-last 20 --prune
restic -r "$2" "$@" check
