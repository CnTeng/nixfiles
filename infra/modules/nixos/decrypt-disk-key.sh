#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

sops --extract '["disk_key"]' -d "$SCRIPT_DIR/../../secrets.yaml"
