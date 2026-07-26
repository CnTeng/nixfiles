locals {
  public_output = jsonencode(merge(
    { r2 = local.r2_public_output },
    { hosts = local.hosts_public_output },
  ))
  private_output = yamlencode(merge(
    { tokens = local.tokens_output },
    { r2 = local.r2_private_output },
    { hosts = local.hosts_private_output },
  ))
}

resource "terraform_data" "output" {
  triggers_replace = {
    public_output  = local.public_output
    private_output = local.private_output
  }

  provisioner "local-exec" {
    command = <<-EOF
    mkdir -p "$OUTPUT_DIR"

    printf '%s\n' "$PUBLIC_OUTPUT" | jq . >"$OUTPUT_DIR/$PUBLIC_FILE"

    printf '%s\n' "$PRIVATE_OUTPUT" | sops --config "$CONFIG_FILE" \
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
}
