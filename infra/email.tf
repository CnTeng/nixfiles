resource "cloudflare_email_routing_settings" "snakepi_eu_org" {
  zone_id = module.zone["sp_eo"].id
  enabled = "true"
}

resource "cloudflare_email_routing_address" "vault" {
  account_id = local.secrets.cloudflare.account_id
  email      = "jstengyufei@gmail.com"
}

resource "cloudflare_email_routing_rule" "vault" {
  zone_id = module.zone["sp_eo"].id
  name    = "vault email rule"
  enabled = true

  matcher {
    type  = "literal"
    field = "to"
    value = "vault@snakepi.eu.org"
  }

  action {
    type  = "forward"
    value = ["jstengyufei@gmail.com"]
  }
}

resource "cloudflare_email_routing_rule" "auth" {
  zone_id = module.zone["sp_eo"].id
  name    = "auth email rule"
  enabled = true

  matcher {
    type  = "literal"
    field = "to"
    value = "auth@snakepi.eu.org"
  }

  action {
    type  = "forward"
    value = ["jstengyufei@gmail.com"]
  }
}

resource "cloudflare_email_routing_rule" "hydra" {
  zone_id = module.zone["sp_eo"].id
  name    = "hydra email rule"
  enabled = true

  matcher {
    type  = "literal"
    field = "to"
    value = "hydra@snakepi.eu.org"
  }

  action {
    type  = "forward"
    value = ["jstengyufei@gmail.com"]
  }
}
