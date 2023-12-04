locals {
  sp_eo_rules = {
    auth  = "auth@snakepi.eu.org"
    vault = "vault@snakepi.eu.org"
  }
  sp_xyz_rules = {
    me = "me@snakepi.xyz"
  }
}

resource "cloudflare_email_routing_settings" "sp_eo" {
  zone_id = cloudflare_zone.zones["sp_eo"].id
  enabled = "true"
}

resource "cloudflare_email_routing_settings" "sp_xyz" {
  zone_id = cloudflare_zone.zones["sp_xyz"].id
  enabled = "true"
}

resource "cloudflare_email_routing_address" "gmail_hk" {
  account_id = local.secrets.cloudflare.account_id
  email      = "jstengyufei@gmail.com"
}

resource "cloudflare_email_routing_address" "gmail_jp" {
  account_id = local.secrets.cloudflare.account_id
  email      = "istengyf@gmail.com"
}

resource "cloudflare_email_routing_rule" "sp_eo_rules" {
  for_each = local.sp_eo_rules
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

resource "cloudflare_email_routing_rule" "sp_xyz_rules" {
  for_each = local.sp_xyz_rules
  zone_id  = cloudflare_zone.zones["sp_xyz"].id
  name     = "${each.key} email rule"
  enabled  = true

  matcher {
    type  = "literal"
    field = "to"
    value = each.value
  }

  action {
    type  = "forward"
    value = ["istengyf@gmail.com"]
  }
}
