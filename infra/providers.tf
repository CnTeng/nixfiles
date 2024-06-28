terraform {
  required_providers {
    aws        = { source = "registry.terraform.io/hashicorp/aws" }
    cloudflare = { source = "registry.terraform.io/cloudflare/cloudflare" }
    external   = { source = "registry.terraform.io/hashicorp/external" }
    github     = { source = "registry.terraform.io/integrations/github" }
    hcloud     = { source = "registry.terraform.io/hetznercloud/hcloud" }
    null       = { source = "registry.terraform.io/hashicorp/null" }
    shell      = { source = "registry.terraform.io/scottwinkler/shell" }
    sops       = { source = "registry.terraform.io/carlpett/sops" }
    tls        = { source = "registry.terraform.io/hashicorp/tls" }
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
