terraform {
  required_providers {
    aws        = { source = "registry.terraform.io/hashicorp/aws" }
    cloudflare = { source = "registry.terraform.io/cloudflare/cloudflare" }
    external   = { source = "registry.terraform.io/hashicorp/external" }
    hcloud     = { source = "registry.terraform.io/hetznercloud/hcloud" }
    null       = { source = "registry.terraform.io/hashicorp/null" }
    sops       = { source = "registry.terraform.io/carlpett/sops" }
    tls        = { source = "registry.terraform.io/hashicorp/tls" }
  }
}
