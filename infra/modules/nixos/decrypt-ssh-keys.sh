#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

extract_key() {
	local key_host=$1
	local key_path=$2

	mkdir -p "$key_path"

	for key_name in ssh_host_ed25519_key ssh_host_ed25519_key.pub; do
		umask "$([[ $key_name == *.pub ]] && echo 0133 || echo 0177)"

		sops --extract '["ssh_keys"]["'"$key_host"'"]["'"$key_name"'"]' \
			-d "$SCRIPT_DIR/../../secrets.yaml" >"./$key_path/$key_name"

		umask 0022
	done
}

extract_key "$HOST_NAME" persist/etc/ssh
extract_key "${HOST_NAME}_initrd" persist/etc/secrets/initrd
