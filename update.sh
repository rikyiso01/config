#!/usr/bin/env bash

set -e

cd "$(dirname $0)"

dconf dump / | dconf2nix > dconf.nix
