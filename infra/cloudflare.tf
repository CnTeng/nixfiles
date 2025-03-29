locals {
  zones = {
    sp_xyz = { zone = "snakepi.xyz" }
    sp_eo  = { zone = "snakepi.eu.org" }
    ms_eo  = { zone = "mrsnake.eu.org" }
  }
}

resource "cloudflare_zone" "zones" {
  for_each = local.zones
  account = {
    id = local.secrets.cloudflare.account_id
  }
  name = each.value.zone
}

data "cloudflare_api_token_permission_groups_list" "all" {}

locals {
  cf_api_permissions = {
    for x in data.cloudflare_api_token_permission_groups_list.all.result :
    x.name => x.id if contains([
      "Zone Read",
      "DNS Write",
      "Workers R2 Storage Bucket Item Write",
    ], x.name)
  }
}

resource "cloudflare_api_token" "cdntls" {
  name   = "cdntls"
  status = "active"
  policies = [{
    effect = "allow"
    permission_groups = [
      { id = local.cf_api_permissions["DNS Write"] },
      { id = local.cf_api_permissions["Zone Read"] },
    ]
    resources = {
      "com.cloudflare.api.account.zone.*" = "*"
    }
  }]
}

locals {
  tokens_output = {
    cf_tls_token = cloudflare_api_token.cdntls.value
  }
}
