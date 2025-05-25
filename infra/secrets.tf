data "sops_file" "secrets" {
  source_file = "secrets.yaml"
}

locals {
  secrets = yamldecode(data.sops_file.secrets.raw)
}

provider "aws" {
  region     = "ap-southeast-1"
  access_key = local.secrets.aws.access_key
  secret_key = local.secrets.aws.secret_key
}

provider "cloudflare" {
  api_token = local.secrets.cloudflare.token
}

provider "hcloud" {
  token = local.secrets.hcloud.token
}

provider "github" {
  token = local.secrets.github.token
}

provider "tailscale" {
  api_key = local.secrets.tailscale.token
}
