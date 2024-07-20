#!/usr/bin/env bash

set -eou pipefail

cd "$(dirname "$0")"

passwd
secret-tool store --label='Keepass password' keepass password
rclone config
