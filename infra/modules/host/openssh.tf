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

data "external" "ssh_to_age" {
  count = var.openssh ? 1 : 0

  program = ["bash", "${path.module}/scripts/ssh-to-age.sh"]

  query = {
    ssh_public_key = one(tls_private_key.host_ed25519_key[*].public_key_openssh)
  }
}

output "openssh" {
  value = var.openssh
}

output "age_public_key" {
  value = one(data.external.ssh_to_age[*].result.age_public_key)
}

output "host_rsa_key" {
  value = {
    public_key  = var.openssh ? trimspace(one(tls_private_key.host_rsa_key[*].public_key_openssh)) : null
    private_key = one(tls_private_key.host_rsa_key[*].private_key_openssh)
  }
  sensitive = true
}

output "host_ed25519_key" {
  value = {
    public_key  = var.openssh ? trimspace(one(tls_private_key.host_ed25519_key[*].public_key_openssh)) : null
    private_key = one(tls_private_key.host_ed25519_key[*].private_key_openssh)
  }
  sensitive = true
}
