variable "cf_zone_id" {
  type = string
}

resource "cloudflare_record" "host_ipv4" {
  count = var.type == "remote" ? 1 : 0

  zone_id = var.cf_zone_id
  name    = var.name
  value   = var.ip.ipv4
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "host_ipv6" {
  count = var.type == "remote" ? 1 : 0

  zone_id = var.cf_zone_id
  name    = var.name
  value   = var.ip.ipv6
  type    = "AAAA"
  proxied = false
}
