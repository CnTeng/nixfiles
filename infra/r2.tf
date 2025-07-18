resource "cloudflare_r2_bucket" "backups" {
  account_id    = local.secrets.cloudflare.account_id
  name          = "backups"
  location      = "APAC"
  storage_class = "Standard"
}

resource "cloudflare_api_token" "r2_backups" {
  name   = "r2_backups"
  status = "active"
  policies = [{
    effect = "allow"
    permission_groups = [
      { id = local.cf_api_permissions["Workers R2 Storage Bucket Item Write"] },
    ]
    resources = {
      "com.cloudflare.edge.r2.bucket.${local.secrets.cloudflare.account_id}_default_backups" = "*"
    }
  }]
}

locals {
  r2_output = {
    backups = {
      endpoint   = "https://${local.secrets.cloudflare.account_id}.r2.cloudflarestorage.com/backups"
      access_key = cloudflare_api_token.r2_backups.id
      secret_key = sha256(cloudflare_api_token.r2_backups.value)
    }
  }
}
