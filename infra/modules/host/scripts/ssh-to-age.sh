#!/usr/bin/env bash

set -euo pipefail

SSH_PUBLIC_KEY=$(jq -r '.ssh_public_key')

AGE_PUBLIC_KEY=$(echo "$SSH_PUBLIC_KEY" | ssh-to-age)

jq -n --arg age_public_key "$AGE_PUBLIC_KEY" '{"age_public_key": $age_public_key}'
