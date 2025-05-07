terraform {
  required_providers {
    cloudflare = { source = "cloudflare/cloudflare" }
    shell      = { source = "scottwinkler/shell" }
    tailscale  = { source = "tailscale/tailscale" }
    tls        = { source = "hashicorp/tls" }
  }
}
