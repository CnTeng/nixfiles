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

resource "cloudflare_api_token" "r2" {
  name = "r2"

  policy {
    permission_groups = [
      data.cloudflare_api_token_permission_groups.all.account["Workers R2 Storage Write"],
    ]
    resources = {
      "com.cloudflare.api.account.*" = "*"
    }
  }
}

output "cf_api_token" {
  value     = cloudflare_api_token.cdntls.value
  sensitive = true
}

output "r2_api_token" {
  value     = cloudflare_api_token.r2.value
  sensitive = true
}
