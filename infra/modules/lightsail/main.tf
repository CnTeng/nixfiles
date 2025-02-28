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
    aws = { source = "hashicorp/aws" }
    tls = { source = "hashicorp/tls" }
  }
}

locals {
  firewall_allowed_ports = {
    tcp = toset([22, 80, 443, 10808])
    udp = toset([2333])
  }
}

resource "aws_lightsail_instance" "instance" {
  name              = var.hostname
  availability_zone = var.region
  blueprint_id      = "ubuntu_22_04"
  bundle_id         = var.plan
}

resource "aws_lightsail_static_ip" "ipv4" {
  name = "${var.hostname}-v4"
}

resource "aws_lightsail_static_ip_attachment" "ipv4" {
  static_ip_name = aws_lightsail_static_ip.ipv4.id
  instance_name  = aws_lightsail_instance.instance.id
}

resource "aws_lightsail_instance_public_ports" "main" {
  instance_name = aws_lightsail_instance.instance.name

  dynamic "port_info" {
    for_each = flatten([
      for protocol, ports in local.firewall_allowed_ports : [
        for port in ports : {
          protocol = protocol
          port     = port
        }
      ]
    ])

    content {
      protocol          = port_info.value.protocol
      from_port         = port_info.value.port
      to_port           = port_info.value.port
      cidrs             = ["0.0.0.0/0"]
      cidr_list_aliases = []
      ipv6_cidrs        = ["::/0", ]
    }
  }
}

output "ip" {
  value = {
    ipv4 = aws_lightsail_instance.instance.public_ip_address
    ipv6 = aws_lightsail_instance.instance.ipv6_addresses[0]
  }
}
