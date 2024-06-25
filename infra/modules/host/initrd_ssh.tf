variable "initrd_ssh" {
  type = bool
}

resource "tls_private_key" "initrd_host_rsa_key" {
  count = var.initrd_ssh ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_private_key" "initrd_host_ed25519_key" {
  count = var.initrd_ssh ? 1 : 0

  algorithm = "ED25519"
}

output "initrd_ssh" {
  value = var.initrd_ssh
}

output "initrd_host_rsa_key" {
  value = {
    public_key  = var.initrd_ssh ? trimspace(one(tls_private_key.initrd_host_rsa_key[*].public_key_openssh)) : null
    private_key = one(tls_private_key.initrd_host_rsa_key[*].private_key_openssh)
  }
  sensitive = true
}

output "initrd_host_ed25519_key" {
  value = {
    public_key  = var.initrd_ssh ? trimspace(one(tls_private_key.initrd_host_ed25519_key[*].public_key_openssh)) : null
    private_key = one(tls_private_key.initrd_host_ed25519_key[*].private_key_openssh)
  }
  sensitive = true
}
