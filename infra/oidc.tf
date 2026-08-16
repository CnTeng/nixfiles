locals {
  oidc_clients = {
    miniflux = {
      callback_urls = ["https://rss.snakepi.xyz/oauth2/oidc/callback"]
      launch_url    = "https://rss.snakepi.xyz"
    }

    outline = {
      callback_urls = ["https://wiki.snakepi.xyz/auth/oidc.callback"]
      launch_url    = "https://wiki.snakepi.xyz"
    }
  }
}

resource "pocketid_client" "clients" {
  for_each = local.oidc_clients

  name          = each.key
  callback_urls = each.value.callback_urls

  pkce_enabled = true
  launch_url   = each.value.launch_url
}

locals {
  oidc_private_output = {
    for name, client in pocketid_client.clients : name => {
      client_id     = client.id
      client_secret = client.client_secret
    }
  }
}
