locals {
  rules = {
    noreply = { from = "noreply@snakepi.xyz", to = "istengyf@gmail.com" }
    main    = { from = "me@snakepi.xyz", to = "rxsnakepi@gmail.com" }
  }
}

resource "cloudflare_email_routing_settings" "main" {
  zone_id = cloudflare_zone.zones["sp_xyz"].id
}

resource "cloudflare_email_routing_address" "main" {
  account_id = local.secrets.cloudflare.account_id
  email      = "rxsnakepi@gmail.com"
}

resource "cloudflare_email_routing_address" "noreply" {
  account_id = local.secrets.cloudflare.account_id
  email      = "istengyf@gmail.com"
}

resource "cloudflare_email_routing_rule" "rules" {
  for_each = local.rules
  zone_id  = cloudflare_zone.zones["sp_xyz"].id
  name     = "${each.key} email rule"
  enabled  = true

  matchers = [{
    type  = "literal"
    field = "to"
    value = each.value.from
  }]

  actions = [{
    type  = "forward"
    value = [each.value.to]
  }]
}
