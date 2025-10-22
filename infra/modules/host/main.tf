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

variable "deploy_key" {
  type = string
}

output "system" {
  value = var.system
}

output "type" {
  value = var.type
}

output "ipv4" {
  value = try(var.ip.ipv4, null)
}

output "ipv6" {
  value = try(var.ip.ipv6, null)
}
