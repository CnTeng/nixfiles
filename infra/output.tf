locals {
  hosts_ip   = merge(module.hcloud, module.lightsail)
  hosts_ipv4 = { for host, ip in local.hosts_ip : "${host}-ipv4" => ip.ipv4 }
  hosts_ipv6 = { for host, ip in local.hosts_ip : "${host}-ipv6" => ip.ipv6 }
  hosts      = merge(local.hosts_ipv4, local.hosts_ipv6)

  r2_endpoints   = { for r2, keys in module.r2 : "${r2}-endpoint" => keys.endpoint }
  r2_access_keys = { for r2, keys in module.r2 : "${r2}-access-key" => keys.access_key }
  r2_secret_keys = { for r2, keys in module.r2 : "${r2}-secret-key" => keys.secret_key }
  r2             = merge(local.r2_endpoints, local.r2_access_keys, local.r2_secret_keys)

  tokens = { cf-api-token = cloudflare_api_token.cdntls.value }

  output = yamlencode(merge(local.hosts, local.r2, local.tokens))
}

resource "null_resource" "output" {
  provisioner "local-exec" {
    command = <<-EOF
    echo "$CONTENT" | sops --config "$CONFIG_FILE" \
      --input-type yaml \
      --output-type yaml \
      --filename-override infra/output.yaml \
      --encrypt /dev/stdin > "$OUTPUT_FILE"
    EOF

    environment = {
      CONFIG_FILE = "${path.root}/../.sops.yaml"
      CONTENT     = nonsensitive(local.output)
      OUTPUT_FILE = "output.yaml"
    }
  }

  triggers = {
    content = local.output
  }
}
