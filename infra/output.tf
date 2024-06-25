locals {
  tokens = { cf_cdntls = cloudflare_api_token.cdntls.value }
  r2     = module.r2

  public_hosts = {
    for host, outputs in module.host :
    host => {
      for name, output in outputs :
      name => output if !issensitive(output)
    }
  }

  private_hosts = {
    for host, outputs in module.host :
    host => {
      for name, output in outputs :
      name => output if issensitive(output)
    }
  }

  public_output = jsonencode({ hosts = local.public_hosts })
  private_output = yamlencode(merge(
    { hosts = local.private_hosts },
    { tokens = local.tokens },
    { r2 = local.r2 }
  ))
}

resource "null_resource" "output" {
  provisioner "local-exec" {
    command = <<-EOF
mkdir -p "$OUTPUT_DIR"

echo "$PUBLIC_OUTPUT" | jq . >"$OUTPUT_DIR/$PUBLIC_FILE"

echo "$PRIVATE_OUTPUT" | sops --config "$CONFIG_FILE" \
	--input-type yaml \
	--output-type yaml \
	--filename-override "infra/$OUTPUT_DIR/$PRIVATE_FILE" \
	--encrypt /dev/stdin >"$OUTPUT_DIR/$PRIVATE_FILE"
    EOF

    environment = {
      CONFIG_FILE    = "${path.root}/../.sops.yaml"
      PUBLIC_OUTPUT  = nonsensitive(local.public_output)
      PRIVATE_OUTPUT = nonsensitive(local.private_output)
      OUTPUT_DIR     = "outputs"
      PUBLIC_FILE    = "data.json"
      PRIVATE_FILE   = "secrets.yaml"
    }
  }

  triggers = {
    public_output  = local.public_output
    private_output = local.private_output
  }
}
