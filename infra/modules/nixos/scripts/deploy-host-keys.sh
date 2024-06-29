#!/usr/bin/env bash

set -euo pipefail

mkdir -p /var/lib/sops-nix
echo "$AGE_PRIVATE_KEY" >/var/lib/sops-nix/key

chmod 700 /var/lib/sops-nix
chmod 600 /var/lib/sops-nix/key
