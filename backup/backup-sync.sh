#!/usr/bin/env bash

set -euo pipefail

rsync -gloptruv --info=progress2 "$1" "$2"
