#!/usr/bin/env bash

set -euo pipefail

restic forget --keep-last 3 --prune
restic check
