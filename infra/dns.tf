locals {
  dns_rec = {
    "@"    = { content = module.host["hcde"].ipv4 }
    anki   = { content = module.host["hcde"].ipv4 }
    atuin  = { content = module.host["hcde"].ipv4 }
    id     = { content = module.host["hcde"].ipv4 }
    note   = { content = module.host["hcde"].ipv4 }
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
  name    = each.key == "@" ? cloudflare_zone.zones["sp_xyz"].name : "${each.key}.${cloudflare_zone.zones["sp_xyz"].name}"
  ttl     = 1
  type    = "A"
  content = each.value.content
  proxied = lookup(each.value, "proxied", true)
}

resource "cloudflare_ruleset" "note_cache_bypass" {
  zone_id     = cloudflare_zone.zones["sp_xyz"].id
  name        = "note cache rules"
  description = "Bypass cache for note"
  kind        = "zone"
  phase       = "http_request_cache_settings"

  rules = [{
    description = "Bypass cache for note"
    expression  = "(http.host eq \"note.snakepi.xyz\")"
    action      = "set_cache_settings"
    action_parameters = {
      cache = false
    }
  }]
}
