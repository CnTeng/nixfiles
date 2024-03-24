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
    hcloud = { source = "registry.terraform.io/hetznercloud/hcloud" }
    tls    = { source = "registry.terraform.io/hashicorp/tls" }
  }
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
  firewall_ids = [hcloud_firewall.default.id]
}

resource "tls_private_key" "temp" {
  algorithm = "ED25519"
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
    protocol  = "tcp"
    port      = "2222"
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
  value = hcloud_primary_ip.ipv6.ip_address
}

output "temp_private_key" {
  value = tls_private_key.temp.private_key_openssh
}
