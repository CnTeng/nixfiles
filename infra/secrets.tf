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

provider "hcloud" {
  token = local.secrets.hcloud.hcloud_token
}

provider "cloudflare" {
  api_token = local.secrets.cloudflare.api_token
}

provider "aws" {
  alias  = "r2"
  region = "us-east-1"

  skip_credentials_validation = true
  skip_region_validation      = true
  skip_requesting_account_id  = true

  access_key = local.secrets.cloudflare.r2_access_key
  secret_key = local.secrets.cloudflare.r2_secret_key

  endpoints {
    s3 = "https://${local.secrets.cloudflare.account_id}.r2.cloudflarestorage.com"
  }
}
