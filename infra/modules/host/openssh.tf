resource "tls_private_key" "host_rsa_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_private_key" "host_ed25519_key" {
  algorithm = "ED25519"
}

output "host_rsa_key_pub" {
  value     = trimspace(tls_private_key.host_rsa_key.public_key_openssh)
  sensitive = true
}

output "host_ed25519_key_pub" {
  value     = trimspace(tls_private_key.host_ed25519_key.public_key_openssh)
  sensitive = true
}

output "host_rsa_key" {
  value     = tls_private_key.host_rsa_key.private_key_openssh
  sensitive = true
}

output "host_ed25519_key" {
  value     = tls_private_key.host_ed25519_key.private_key_openssh
  sensitive = true
}
