#!/usr/bin/env bash

set -euo pipefail

target="$1"
shift

restic -r "$(dirname "$0")" "$@" restore latest --target "$target"

