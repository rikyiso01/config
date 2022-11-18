#!/usr/bin/env bash

set -euo pipefail

if [[ "$EUID" != 0 ]]
then echo 'Please run as root'
    exit 1
fi

nohup dockerd -H 'unix:///var/run/docker.sock' > /dev/null 2> /dev/null &