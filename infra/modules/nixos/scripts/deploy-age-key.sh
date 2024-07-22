#!/usr/bin/env bash

set -euo pipefail

SOPS_NIX=persist/var/lib/sops-nix

mkdir -p "$SOPS_NIX"
echo "$AGE_PRIVATE_KEY" >"$SOPS_NIX/key"

chmod 700 "$SOPS_NIX"
chmod 600 "$SOPS_NIX/key"
