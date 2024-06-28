variable "name" {
  type = string
}

variable "system" {
  type = string
}

variable "type" {
  type = string

  validation {
    condition     = contains(["remote", "local"], var.type)
    error_message = "Type must be 'remote' or 'local'."
  }
}

variable "ip" {
  type = object({
    ipv4 = optional(string)
    ipv6 = optional(string)
  })
}

output "system" {
  value = var.system
}

output "type" {
  value = var.type
}

output "ip" {
  value     = var.ip
  sensitive = true
}
