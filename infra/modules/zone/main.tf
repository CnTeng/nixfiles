variable "account_id" {
  type = string
}

variable "zone" {
  type = string
}

terraform {
  required_providers {
    cloudflare = { source = "cloudflare/cloudflare" }
  }
}

resource "cloudflare_zone" "zone" {
  account_id = var.account_id
  zone       = var.zone
}

output "id" {
  value = cloudflare_zone.zone.id
}
