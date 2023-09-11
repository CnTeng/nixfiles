provider "cloudflare" {
  api_token = local.secrets.cloudflare.api_token
}

resource "cloudflare_record" "rxaws" {
  zone_id = local.secrets.cloudflare.zone_id
  name    = "rxaws"
  value   = local.secrets.cloudflare.rxaws_ip
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "rxhz" {
  zone_id = local.secrets.cloudflare.zone_id
  name    = "rxhz"
  value   = local.secrets.cloudflare.rxhz_ip
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "book" {
  zone_id = local.secrets.cloudflare.zone_id
  name    = "book"
  value   = local.secrets.cloudflare.rxhz_ip
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "cache" {
  zone_id = local.secrets.cloudflare.zone_id
  name    = "cache"
  value   = local.secrets.cloudflare.rxhz_ip
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "hydra" {
  zone_id = local.secrets.cloudflare.zone_id
  name    = "hydra"
  value   = local.secrets.cloudflare.rxhz_ip
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "pwd" {
  zone_id = local.secrets.cloudflare.zone_id
  name    = "pwd"
  value   = local.secrets.cloudflare.rxhz_ip
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "rsshub" {
  zone_id = local.secrets.cloudflare.zone_id
  name    = "rsshub"
  value   = local.secrets.cloudflare.rxhz_ip
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "rss" {
  zone_id = local.secrets.cloudflare.zone_id
  name    = "rss"
  value   = local.secrets.cloudflare.rxhz_ip
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "domain" {
  zone_id = local.secrets.cloudflare.zone_id
  name    = local.secrets.cloudflare.domain
  value   = local.secrets.cloudflare.rxhz_ip
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "www" {
  zone_id = local.secrets.cloudflare.zone_id
  name    = "www"
  value   = local.secrets.cloudflare.rxhz_ip
  type    = "A"
  proxied = true
}
