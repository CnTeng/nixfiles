resource "tailscale_tailnet_key" "tailnet_key" {
  reusable      = true
  preauthorized = true
}

output "tailnet_key" {
  value     = tailscale_tailnet_key.tailnet_key.key
  sensitive = true
}
