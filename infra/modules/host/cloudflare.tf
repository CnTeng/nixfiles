variable "zone_id" {
  type = string
}

resource "cloudflare_dns_record" "host_rec_v4" {
  count = var.type == "remote" ? 1 : 0

  zone_id = var.zone_id
  name    = var.name
  ttl     = 1
  type    = "A"
  content = var.ip.ipv4
  proxied = false
}

resource "cloudflare_dns_record" "host_rec_v6" {
  count = var.type == "remote" ? 1 : 0

  zone_id = var.zone_id
  name    = "${var.name}.v6"
  ttl     = 1
  type    = "AAAA"
  content = var.ip.ipv6
  proxied = false
}
