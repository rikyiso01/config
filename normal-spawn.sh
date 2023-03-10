#!/usr/bin/env bash

exec /usr/bin/env flatpak-spawn --host "$(basename "$0")" "$@"