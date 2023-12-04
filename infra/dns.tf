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
