variable "openssh" {
  type = bool
}

resource "tls_private_key" "host_rsa_key" {
  count = var.openssh ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_private_key" "host_ed25519_key" {
  count = var.openssh ? 1 : 0

  algorithm = "ED25519"
}

output "openssh" {
  value = var.openssh
}

output "host_rsa_key_pub" {
  value = var.openssh ? trimspace(one(tls_private_key.host_rsa_key[*].public_key_openssh)) : null
}

output "host_ed25519_key_pub" {
  value = var.openssh ? trimspace(one(tls_private_key.host_ed25519_key[*].public_key_openssh)) : null
}

output "host_rsa_key" {
  value     = one(tls_private_key.host_rsa_key[*].private_key_openssh)
  sensitive = true
}

output "host_ed25519_key" {
  value     = one(tls_private_key.host_ed25519_key[*].private_key_openssh)
  sensitive = true
}
