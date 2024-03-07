terraform {
  required_providers {
    aws        = { source = "hashicorp/aws" }
    cloudflare = { source = "cloudflare/cloudflare" }
    external   = { source = "hashicorp/external" }
    hcloud     = { source = "hetznercloud/hcloud" }
    null       = { source = "hashicorp/null" }
    sops       = { source = "carlpett/sops" }
    tls        = { source = "hashicorp/tls" }
  }
}
