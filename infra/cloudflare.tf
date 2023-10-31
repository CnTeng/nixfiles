data "cloudflare_api_token_permission_groups" "all" {}

resource "cloudflare_api_token" "cdntls" {
  name = "cdntls"

  policy {
    permission_groups = [
      data.cloudflare_api_token_permission_groups.all.zone["DNS Read"],
      data.cloudflare_api_token_permission_groups.all.zone["Zone Read"],
    ]
    resources = {
      "com.cloudflare.api.account.zone.*" = "*"
    }
  }
}

output "cloudflare_token" {
  value     = cloudflare_api_token.cdntls.value
  sensitive = true
}
