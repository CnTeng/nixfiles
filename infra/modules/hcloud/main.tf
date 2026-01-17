variable "hostname" {
  type = string
}

variable "plan" {
  type = string
}

variable "region" {
  type = string
}

terraform {
  required_providers {
    hcloud = { source = "hetznercloud/hcloud" }
  }
}

locals {
  firewall_allowed_ports = {
    tcp = toset([22, 80, 443, 10808])
  }
}

resource "hcloud_server" "server" {
  name        = var.hostname
  server_type = var.plan
  image       = "debian-12"
  location    = var.region
  public_net {
    ipv4 = hcloud_primary_ip.ipv4.id
    ipv6 = hcloud_primary_ip.ipv6.id
  }
  firewall_ids = [hcloud_firewall.main.id]
}

resource "hcloud_primary_ip" "ipv4" {
  name          = "${var.hostname}-v4"
  type          = "ipv4"
  location      = var.region
  auto_delete   = false
  assignee_type = "server"
}

resource "hcloud_primary_ip" "ipv6" {
  name          = "${var.hostname}-v6"
  type          = "ipv6"
  location      = var.region
  auto_delete   = false
  assignee_type = "server"
}

resource "hcloud_firewall" "main" {
  name = "${var.hostname}-main"

  dynamic "rule" {
    for_each = flatten([
      for protocol, ports in local.firewall_allowed_ports : [
        for port in ports : {
          protocol = protocol
          port     = tostring(port)
        }
      ]
    ])
    content {
      direction  = "in"
      protocol   = rule.value.protocol
      port       = rule.value.port
      source_ips = ["0.0.0.0/0", "::/0"]
    }
  }
}

output "ip" {
  value = {
    ipv4 = hcloud_primary_ip.ipv4.ip_address
    ipv6 = cidrhost("${hcloud_primary_ip.ipv6.ip_address}/64", 1)
  }
}
