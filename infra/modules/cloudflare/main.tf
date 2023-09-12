variable "zone_id" {
  type = string
}

variable "name" {
  type = string
}

variable "value" {
  type = string
}

variable "type" {
  type    = string
  default = "A"
}

variable "proxied" {
  type    = bool
  default = true
}
variable "priority" {
  type    = number
  default = null
}

terraform {
  required_providers {
    cloudflare = { source = "cloudflare/cloudflare" }
  }
}

resource "cloudflare_record" "record" {
  zone_id  = var.zone_id
  name     = var.name
  value    = var.value
  type     = var.type
  proxied  = var.proxied
  priority = var.priority
}
