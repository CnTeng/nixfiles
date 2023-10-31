locals {
  email_rules = {
    auth  = "auth@snakepi.eu.org"
    hydra = "hydra@snakepi.eu.org"
    vault = "vault@snakepi.eu.org"
  }
}

resource "cloudflare_email_routing_settings" "sp_eo" {
  zone_id = cloudflare_zone.zones["sp_eo"].id
  enabled = "true"
}

resource "cloudflare_email_routing_address" "default" {
  account_id = local.secrets.cloudflare.account_id
  email      = "jstengyufei@gmail.com"
}

resource "cloudflare_email_routing_rule" "rules" {
  for_each = local.email_rules
  zone_id  = cloudflare_zone.zones["sp_eo"].id
  name     = "${each.key} email rule"
  enabled  = true

  matcher {
    type  = "literal"
    field = "to"
    value = each.value
  }

  action {
    type  = "forward"
    value = ["jstengyufei@gmail.com"]
  }
}
