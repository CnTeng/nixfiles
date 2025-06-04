locals {
  dns_rec = {
    "@"    = { content = module.host["hcde"].ipv4 }
    anki   = { content = module.host["hcde"].ipv4 }
    atuin  = { content = module.host["hcde"].ipv4 }
    id     = { content = module.host["hcde"].ipv4 }
    ldap   = { content = module.host["hcde"].ipv4 }
    ntfy   = { content = module.host["hcde"].ipv4 }
    pb     = { content = module.host["hcde"].ipv4 }
    rss    = { content = module.host["hcde"].ipv4 }
    vault  = { content = module.host["hcde"].ipv4 }
    webdav = { content = module.host["hcde"].ipv4 }
    www    = { content = module.host["hcde"].ipv4 }
  }
}

resource "cloudflare_dns_record" "dns_rec" {
  for_each = local.dns_rec

  zone_id = cloudflare_zone.zones["sp_xyz"].id
  name    = each.key
  ttl     = 1
  type    = "A"
  content = each.value.content
  proxied = lookup(each.value, "proxied", true)
}
