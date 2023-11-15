locals {
  zones = {
    sp_xyz = { zone = "snakepi.xyz" }
    sp_eo  = { zone = "snakepi.eu.org" }
    ms_eo  = { zone = "mrsnake.eu.org" }
  }

  web_rec = {
    "@"   = { value = module.hcloud["rxhc0"].ipv4 }
    auth  = { value = module.hcloud["rxhc0"].ipv4 }
    rss   = { value = module.hcloud["rxhc0"].ipv4 }
    ntfy  = { value = module.hcloud["rxhc0"].ipv4 }
    vault = { value = module.hcloud["rxhc0"].ipv4 }
    www   = { value = module.hcloud["rxhc0"].ipv4 }
    naive = { value = module.lightsail["rxls0"].ipv4, proxied = false }
  }

  pm_rec = {
    verify = {
      name  = "@"
      value = local.secrets.protonmail.verify
      type  = "TXT"
    }
    MX1 = {
      name     = "@"
      value    = "mail.protonmail.ch"
      type     = "MX"
      priority = 10
    }
    MX2 = {
      name     = "@"
      value    = "mailsec.protonmail.ch"
      type     = "MX"
      priority = 20
    }
    SPF = {
      name  = "@"
      value = "v=spf1 include:_spf.protonmail.ch mx ~all"
      type  = "TXT"
    }
    DKIM1 = {
      name  = "protonmail._domainkey"
      value = local.secrets.protonmail.DKIM1
      type  = "CNAME"
    }
    DKIM2 = {
      name  = "protonmail2._domainkey"
      value = local.secrets.protonmail.DKIM2
      type  = "CNAME"
    }
    DKIM3 = {
      name  = "protonmail3._domainkey"
      value = local.secrets.protonmail.DKIM3
      type  = "CNAME"
    }
    DMARC = {
      name  = "_dmarc"
      value = local.secrets.protonmail.DMARC
      type  = "TXT"
    }
  }
}

resource "cloudflare_zone" "zones" {
  for_each   = local.zones
  account_id = local.secrets.cloudflare.account_id
  zone       = each.value.zone
}

resource "cloudflare_record" "web_rec" {
  for_each = local.web_rec
  zone_id  = cloudflare_zone.zones["sp_xyz"].id
  name     = each.key
  value    = each.value.value
  type     = "A"
  proxied  = can(each.value.proxied) ? each.value.proxied : true
  priority = can(each.value.priority) ? each.value.priority : null
}

resource "cloudflare_record" "pm_rec" {
  for_each = local.pm_rec
  zone_id  = cloudflare_zone.zones["sp_xyz"].id
  name     = each.value.name
  value    = each.value.value
  type     = each.value.type
  proxied  = false
  priority = can(each.value.priority) ? each.value.priority : null
}
