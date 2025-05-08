terraform {
  required_providers {
    aws        = { source = "hashicorp/aws" }
    cloudflare = { source = "cloudflare/cloudflare" }
    github     = { source = "integrations/github" }
    hcloud     = { source = "hetznercloud/hcloud" }
    null       = { source = "hashicorp/null" }
    sops       = { source = "carlpett/sops" }
    tailscale  = { source = "tailscale/tailscale" }
    tls        = { source = "hashicorp/tls" }
  }

  encryption {
    method "aes_gcm" "default" {
      keys = key_provider.pbkdf2.default
    }

    state {
      method   = method.aes_gcm.default
      enforced = true
    }
  }
}
