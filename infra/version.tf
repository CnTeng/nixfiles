terraform {
  required_providers {
    sops = { source = "carlpett/sops" }

    aws = { source = "hashicorp/aws" }

    hcloud = { source = "hetznercloud/hcloud" }

    cloudflare = { source = "cloudflare/cloudflare" }

    hydra = { source = "DeterminateSystems/hydra" }
  }
}

