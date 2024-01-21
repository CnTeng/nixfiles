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

resource "hcloud_server" "server" {
  name        = var.hostname
  server_type = var.plan
  image       = "ubuntu-22.04"
  datacenter  = var.region
  public_net {
    ipv4 = hcloud_primary_ip.ipv4.id
    ipv6 = hcloud_primary_ip.ipv6.id
  }
  firewall_ids = [hcloud_firewall.default.id]
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

resource "hcloud_firewall" "default" {
  name = "${var.hostname}-default"
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "80"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "443"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
  rule {
    direction = "in"
    protocol  = "udp"
    port      = "1080"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

output "ipv4" {
  value = hcloud_primary_ip.ipv4.ip_address
}

output "ipv6" {
  value = hcloud_primary_ip.ipv6.ip_network
}
