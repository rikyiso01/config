#!/usr/bin/env bash

set -euo pipefail

trap ctrl_c INT

function ctrl_c() {
    pactl unload-module module-null-sink
}

pactl load-module module-null-sink 'media.class=Audio/Sink' 'sink_name=my-sink' 'channel_map=surround-51'
flatpak run --command=cvlc org.videolan.VLC -vvv 'pulse://my-sink' --sout '#transcode{acodec=mp3,ab=128,channels=2}:standard{access=http,dst=0.0.0.0:8888/pc.mp3}'
