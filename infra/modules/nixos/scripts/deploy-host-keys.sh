#!/usr/bin/env bash

set -euo pipefail

deploy_ssh_key() {
	local public_key=$1
	local private_key=$2
	local type=$3
	local path=$4

	local public_key_path="$path/ssh_host_${type}_key.pub"
	local private_key_path="$path/ssh_host_${type}_key"

	mkdir -p "$path"

	echo "$public_key" >"$public_key_path"
	echo "$private_key" >"$private_key_path"

	chmod 644 "$public_key_path"
	chmod 600 "$private_key_path"
}

deploy_ssh_key "$RSA_PUBLIC_KEY" "$RSA_PRIVATE_KEY" rsa persist/etc/ssh
deploy_ssh_key "$ED25519_PUBLIC_KEY" "$ED25519_PRIVATE_KEY" ed25519 persist/etc/ssh
deploy_ssh_key "$INITRD_RSA_PUBLIC_KEY" "$INITRD_RSA_PRIVATE_KEY" rsa persist/etc/secrets/initrd
deploy_ssh_key "$INITRD_ED25519_PUBLIC_KEY" "$INITRD_ED25519_PRIVATE_KEY" ed25519 persist/etc/secrets/initrd
