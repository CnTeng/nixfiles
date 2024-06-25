locals {
  zones = {
    sp_xyz = { zone = "snakepi.xyz" }
    sp_eo  = { zone = "snakepi.eu.org" }
    ms_eo  = { zone = "mrsnake.eu.org" }
  }

  web_rec = {
    "@"   = { value = module.host["hcax"].ip.ipv4 }
    atuin = { value = module.host["hcax"].ip.ipv4 }
    auth  = { value = module.host["hcax"].ip.ipv4 }
    ldap  = { value = module.host["hcax"].ip.ipv4 }
    ntfy  = { value = module.host["hcax"].ip.ipv4 }
    rss   = { value = module.host["hcax"].ip.ipv4 }
    sync  = { value = module.host["hcax"].ip.ipv4 }
    vault = { value = module.host["hcax"].ip.ipv4 }
    www   = { value = module.host["hcax"].ip.ipv4 }
    tuic  = { value = module.host["lssg"].ip.ipv4, proxied = false }
  }
}

resource "cloudflare_zone" "zones" {
  for_each = local.zones

  account_id = local.secrets.cloudflare.account_id
  zone       = each.value.zone
}

resource "cloudflare_record" "web_rec" {
  for_each = local.web_rec

  zone_id = cloudflare_zone.zones["sp_xyz"].id
  name    = each.key
  value   = each.value.value
  type    = "A"
  proxied = lookup(each.value, "proxied", true)
}
