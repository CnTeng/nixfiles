locals {
  web_rec = {
    "@"   = { content = module.host["hcde"].ipv4 }
    atuin = { content = module.host["hcde"].ipv4 }
    auth  = { content = module.host["hcde"].ipv4 }
    ldap  = { content = module.host["hcde"].ipv4 }
    ntfy  = { content = module.host["hcde"].ipv4 }
    pb    = { content = module.host["hcde"].ipv4 }
    rss   = { content = module.host["hcde"].ipv4 }
    vault = { content = module.host["hcde"].ipv4 }
    www   = { content = module.host["hcde"].ipv4 }
  }
}

resource "cloudflare_record" "web_rec" {
  for_each = local.web_rec

  zone_id = cloudflare_zone.zones["sp_xyz"].id
  name    = each.key
  content = each.value.content
  type    = "A"
  proxied = lookup(each.value, "proxied", true)
}
