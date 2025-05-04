#!/usr/bin/env bash

set -euo pipefail

from="$1"
to="$2"
shift
shift

rsync -gloptruv --info=progress2 "$from" "$to"

restic -r "$from" "$@" forget --keep-last 20 --prune
restic -r "$to" "$@" check
