variable "nixbuild" {
  type = bool
}

resource "tls_private_key" "nixbuild_key_pair" {
  count = var.nixbuild ? 1 : 0

  algorithm = "ED25519"
}

output "nixbuild" {
  value = var.nixbuild
}

output "nixbuild_key_pair" {
  value = {
    public_key  = var.nixbuild ? trimspace(one(tls_private_key.nixbuild_key_pair[*].public_key_openssh)) : null
    private_key = one(tls_private_key.nixbuild_key_pair[*].private_key_openssh)
  }
  sensitive = true
}
