variable "initrd_ssh" {
  type = bool
}

resource "tls_private_key" "initrd_rsa_key" {
  count = var.initrd_ssh ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_private_key" "initrd_ed25519_key" {
  count = var.initrd_ssh ? 1 : 0

  algorithm = "ED25519"
}

output "initrd_ssh" {
  value = var.initrd_ssh
}

output "initrd_rsa_key_pub" {
  value = var.initrd_ssh ? trimspace(one(tls_private_key.initrd_rsa_key[*].public_key_openssh)) : null
}

output "initrd_ed25519_key_pub" {
  value = var.initrd_ssh ? trimspace(one(tls_private_key.initrd_ed25519_key[*].public_key_openssh)) : null
}

output "initrd_rsa_key" {
  value     = one(tls_private_key.initrd_rsa_key[*].private_key_openssh)
  sensitive = true
}

output "initrd_ed25519_key" {
  value     = one(tls_private_key.initrd_ed25519_key[*].private_key_openssh)
  sensitive = true
}
