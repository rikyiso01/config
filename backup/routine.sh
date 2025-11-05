#!/usr/bin/env bash

set -euo pipefail

udisksctl unmount -b /dev/sda1 || true
udisksctl mount -b /dev/sda1

mprocs

udisksctl mount -b /dev/sda1 || true
