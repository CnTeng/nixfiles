terraform {
  required_providers {
    cloudflare = { source = "cloudflare/cloudflare" }
    tailscale  = { source = "tailscale/tailscale" }
    tls        = { source = "hashicorp/tls" }
  }
}
