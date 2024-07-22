locals {
  zones = {
    sp_xyz = { zone = "snakepi.xyz" }
    sp_eo  = { zone = "snakepi.eu.org" }
    ms_eo  = { zone = "mrsnake.eu.org" }
  }
}

resource "cloudflare_zone" "zones" {
  for_each = local.zones

  account_id = local.secrets.cloudflare.account_id
  zone       = each.value.zone
}

data "cloudflare_api_token_permission_groups" "all" {}

resource "cloudflare_api_token" "cdntls" {
  name = "cdntls"

  policy {
    permission_groups = [
      data.cloudflare_api_token_permission_groups.all.zone["DNS Write"],
      data.cloudflare_api_token_permission_groups.all.zone["Zone Read"],
    ]
    resources = {
      "com.cloudflare.api.account.zone.*" = "*"
    }
  }
}
