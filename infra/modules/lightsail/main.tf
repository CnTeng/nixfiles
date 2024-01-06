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

resource "aws_lightsail_instance_public_ports" "default" {
  instance_name = aws_lightsail_instance.instance.name
  port_info {
    protocol          = "tcp"
    from_port         = 22
    to_port           = 22
    cidrs             = ["0.0.0.0/0", ]
    cidr_list_aliases = []
    ipv6_cidrs        = ["::/0", ]
  }

  port_info {
    protocol          = "tcp"
    from_port         = 80
    to_port           = 80
    cidrs             = ["0.0.0.0/0", ]
    cidr_list_aliases = []
    ipv6_cidrs        = ["::/0", ]
  }

  port_info {
    protocol          = "tcp"
    from_port         = 443
    to_port           = 443
    cidrs             = ["0.0.0.0/0", ]
    cidr_list_aliases = []
    ipv6_cidrs        = ["::/0", ]
  }

  port_info {
    protocol          = "udp"
    from_port         = 443
    to_port           = 443
    cidrs             = ["0.0.0.0/0", ]
    cidr_list_aliases = []
    ipv6_cidrs        = ["::/0", ]
  }
}

output "ipv4" {
  value = aws_lightsail_instance.instance.public_ip_address
}

output "ipv6" {
  value = aws_lightsail_instance.instance.ipv6_addresses[0]
}
