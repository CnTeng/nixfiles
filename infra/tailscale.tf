resource "tailscale_dns_nameservers" "nameservers" {
  nameservers = ["1.1.1.1"]
}

resource "tailscale_dns_search_paths" "search_paths" {
  search_paths = [
    "snakepi.xyz"
  ]
}

