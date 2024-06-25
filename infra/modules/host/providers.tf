terraform {
  required_providers {
    cloudflare = { source = "registry.terraform.io/cloudflare/cloudflare" }
    external   = { source = "registry.terraform.io/hashicorp/external" }
    shell      = { source = "registry.terraform.io/scottwinkler/shell" }
    tls        = { source = "registry.terraform.io/hashicorp/tls" }
  }
}
