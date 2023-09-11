terraform {
  required_providers {
    cloudflare = { source = "cloudflare/cloudflare" }

    sops = { source = "carlpett/sops" }

    hcloud = { source = "hetznercloud/hcloud" }
  }
}
