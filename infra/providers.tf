terraform {
  required_providers {
    aws        = { source = "hashicorp/aws" }
    cloudflare = { source = "cloudflare/cloudflare" }
    external   = { source = "hashicorp/external" }
    github     = { source = "integrations/github" }
    hcloud     = { source = "hetznercloud/hcloud" }
    null       = { source = "hashicorp/null" }
    shell      = { source = "scottwinkler/shell" }
    sops       = { source = "carlpett/sops" }
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
