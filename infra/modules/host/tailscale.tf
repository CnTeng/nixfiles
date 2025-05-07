resource "tailscale_tailnet_key" "tailnet_key" {
  count = var.type == "local" ? 1 : 0

  reusable      = true
  preauthorized = true
}

data "tailscale_device" "device" {
  count = var.type == "local" ? 1 : 0

  hostname = var.name
  wait_for = "5s"
}

resource "cloudflare_dns_record" "host_rec_ts" {
  count = var.type == "local" ? 1 : 0

  zone_id = var.zone_id
  name    = "${var.name}.ts"
  ttl     = 1
  type    = "CNAME"
  content = data.tailscale_device.device[0].name
  proxied = false
}

output "tailnet_key" {
  value     = one(tailscale_tailnet_key.tailnet_key[*].key)
  sensitive = true
}
