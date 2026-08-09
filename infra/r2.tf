resource "cloudflare_r2_bucket" "backups" {
  account_id    = local.cf_account_id
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
    resources = jsonencode({
      "com.cloudflare.edge.r2.bucket.${local.cf_account_id}_default_${cloudflare_r2_bucket.backups.name}" = "*"
    })
  }]
}

resource "cloudflare_r2_bucket" "nix_cache" {
  account_id    = local.cf_account_id
  name          = "nix-cache"
  location      = "APAC"
  storage_class = "Standard"
}

resource "cloudflare_r2_custom_domain" "nix_cache" {
  account_id  = local.cf_account_id
  bucket_name = cloudflare_r2_bucket.nix_cache.name
  domain      = "cache.snakepi.xyz"
  enabled     = true
  zone_id     = cloudflare_zone.zones["sp_xyz"].id
  min_tls     = "1.2"
}

resource "cloudflare_ruleset" "nix_cache_redirects" {
  zone_id     = cloudflare_zone.zones["sp_xyz"].id
  name        = "nix cache redirects"
  description = "Redirect the nix cache root to its landing page"
  kind        = "zone"
  phase       = "http_request_dynamic_redirect"

  rules = [{
    ref         = "nix_cache_root_to_index"
    description = "Redirect the nix cache root to index.html"
    expression  = "(http.host eq \"${cloudflare_r2_custom_domain.nix_cache.domain}\" and http.request.uri.path eq \"/\")"
    action      = "redirect"
    action_parameters = {
      from_value = {
        target_url = {
          value = "https://${cloudflare_r2_custom_domain.nix_cache.domain}/index.html"
        }
        status_code           = 301
        preserve_query_string = true
      }
    }
  }]
}

resource "cloudflare_api_token" "r2_nix_cache" {
  name   = "r2_nix_cache"
  status = "active"
  policies = [{
    effect = "allow"
    permission_groups = [
      { id = local.cf_api_permissions["Workers R2 Storage Bucket Item Write"] },
    ]
    resources = jsonencode({
      "com.cloudflare.edge.r2.bucket.${local.cf_account_id}_default_${cloudflare_r2_bucket.nix_cache.name}" = "*"
    })
  }]
}

resource "cloudflare_r2_bucket" "outline" {
  account_id    = local.cf_account_id
  name          = "outline"
  location      = "APAC"
  storage_class = "Standard"
}

resource "cloudflare_r2_bucket_cors" "outline" {
  account_id  = local.cf_account_id
  bucket_name = cloudflare_r2_bucket.outline.name

  rules = [{
    id = "outline"
    allowed = {
      origins = ["https://wiki.snakepi.xyz"]
      methods = ["PUT"]
      headers = [
        "cache-control",
        "content-disposition",
        "content-type",
      ]
    }
    max_age_seconds = 3600
  }]
}

resource "cloudflare_api_token" "r2_outline" {
  name   = "r2_outline"
  status = "active"
  policies = [{
    effect = "allow"
    permission_groups = [
      { id = local.cf_api_permissions["Workers R2 Storage Bucket Item Write"] },
    ]
    resources = jsonencode({
      "com.cloudflare.edge.r2.bucket.${local.cf_account_id}_default_${cloudflare_r2_bucket.outline.name}" = "*"
    })
  }]
}

locals {
  r2_public_output = {
    endpoint = "${local.cf_account_id}.r2.cloudflarestorage.com"
  }

  r2_private_output = {
    backups = {
      access_key = cloudflare_api_token.r2_backups.id
      secret_key = sha256(cloudflare_api_token.r2_backups.value)
    }
    nix_cache = {
      access_key = cloudflare_api_token.r2_nix_cache.id
      secret_key = sha256(cloudflare_api_token.r2_nix_cache.value)
    }
    outline = {
      access_key = cloudflare_api_token.r2_outline.id
      secret_key = sha256(cloudflare_api_token.r2_outline.value)
    }
  }
}
