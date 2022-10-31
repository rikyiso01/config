#!/usr/bin/env bash

set -euo pipefail

eval "$(ssh-agent -s)"
echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK;export SSH_AGENT_PID=$SSH_AGENT_PID" > "$HOME/.ssh/environment"
ssh-add "$HOME/.ssh/id_ed25519"