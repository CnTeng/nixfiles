#!/usr/bin/env bash

set -euo pipefail

TEMP_DIR=$(mktemp -t -d syncthing.XXXXXXXX)

function cleanup {
	rm -r "$TEMP_DIR"
}
trap cleanup EXIT

pushd "$TEMP_DIR" >/dev/null

DEVICE_ID=$(
	syncthing generate \
		--no-default-folder \
		--skip-port-probing \
		--config . | awk -F ': ' '/Device ID/ {print $NF}'
)

jq --null-input \
	--arg device_id "$DEVICE_ID" \
	--arg cert_pem "$(cat cert.pem)" \
	--arg key_pem "$(cat key.pem)" \
	'{"device_id": $device_id, "cert_pem": $cert_pem, "key_pem": $key_pem}'

popd >/dev/null
