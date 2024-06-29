variable "zone_id" {
  type = string
}

resource "cloudflare_record" "host_rec_v4" {
  count = var.type == "remote" ? 1 : 0

  zone_id = var.zone_id
  name    = var.name
  value   = var.ip.ipv4
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "host_rec_v6" {
  count = var.type == "remote" ? 1 : 0

  zone_id = var.zone_id
  name    = "${var.name}.v6"
  value   = var.ip.ipv6
  type    = "AAAA"
  proxied = false
}
