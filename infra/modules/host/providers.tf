terraform {
  required_providers {
    cloudflare = { source = "registry.terraform.io/cloudflare/cloudflare" }
    shell      = { source = "registry.terraform.io/scottwinkler/shell" }
    tls        = { source = "registry.terraform.io/hashicorp/tls" }
  }
}
