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
    tls    = { source = "hashicorp/tls" }
  }
}

locals {
  firewall_allowed_ports = {
    tcp = toset([22, 80, 443])
    udp = toset([2333])
  }
}

resource "tls_private_key" "temp" {
  algorithm = "ED25519"
}

resource "hcloud_server" "server" {
  name        = var.hostname
  server_type = var.plan
  image       = "debian-12"
  datacenter  = var.region
  ssh_keys    = [hcloud_ssh_key.temp.id]
  public_net {
    ipv4 = hcloud_primary_ip.ipv4.id
    ipv6 = hcloud_primary_ip.ipv6.id
  }
  firewall_ids = [hcloud_firewall.main.id]
}

resource "hcloud_ssh_key" "temp" {
  name       = "${var.hostname}-temp"
  public_key = tls_private_key.temp.public_key_openssh
}

resource "hcloud_primary_ip" "ipv4" {
  name          = "${var.hostname}-v4"
  type          = "ipv4"
  datacenter    = var.region
  auto_delete   = false
  assignee_type = "server"
}

resource "hcloud_primary_ip" "ipv6" {
  name          = "${var.hostname}-v6"
  type          = "ipv6"
  datacenter    = var.region
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

output "temp_private_key" {
  value     = tls_private_key.temp.private_key_openssh
  sensitive = true
}
