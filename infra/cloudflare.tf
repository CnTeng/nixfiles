locals {
  cf_account_id = one(data.cloudflare_accounts.yufei.result).id

  zones = {
    sp_xyz = { zone = "snakepi.xyz" }
    sp_eo  = { zone = "snakepi.eu.org" }
    ms_eo  = { zone = "mrsnake.eu.org" }
  }
}

data "cloudflare_accounts" "yufei" {
  name = "yufei"
}

resource "cloudflare_zone" "zones" {
  for_each = local.zones

  account = {
    id = local.cf_account_id
  }
  name = each.value.zone
}

resource "cloudflare_zone_setting" "rocket_loader" {
  for_each = local.zones

  zone_id    = cloudflare_zone.zones[each.key].id
  setting_id = "rocket_loader"
  value      = "off"
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
      { id = local.cf_api_permissions["Zone Read"] },
      { id = local.cf_api_permissions["DNS Write"] },
    ]
    resources = jsonencode({
      "com.cloudflare.api.account.zone.*" = "*"
    })
  }]
}

locals {
  tokens_output = {
    cf_tls_token = cloudflare_api_token.cdntls.value
  }
}
