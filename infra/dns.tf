locals {
  web_rec = {
    "@"   = { value = module.host["hcde"].ipv4 }
    atuin = { value = module.host["hcde"].ipv4 }
    auth  = { value = module.host["hcde"].ipv4 }
    ldap  = { value = module.host["hcde"].ipv4 }
    ntfy  = { value = module.host["hcde"].ipv4 }
    rss   = { value = module.host["hcde"].ipv4 }
    vault = { value = module.host["hcde"].ipv4 }
    www   = { value = module.host["hcde"].ipv4 }
  }
}

resource "cloudflare_record" "web_rec" {
  for_each = local.web_rec

  zone_id = cloudflare_zone.zones["sp_xyz"].id
  name    = each.key
  value   = each.value.value
  type    = "A"
  proxied = lookup(each.value, "proxied", true)
}
