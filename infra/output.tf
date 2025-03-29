locals {
  public_output = jsonencode(merge(
    { github = local.github_output },
    { hosts = local.public_hosts_output },
  ))
  private_output = yamlencode(merge(
    { tokens = local.tokens_output },
    { r2 = local.r2_output },
    { hosts = local.private_hosts_output },
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
