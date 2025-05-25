data "github_repository" "nixfiles" {
  full_name = "CnTeng/nixfiles"
}

resource "tls_private_key" "nixos_deploy_key" {
  algorithm = "ED25519"
}

resource "github_actions_secret" "nixos_deploy_key" {
  repository      = "nixfiles"
  secret_name     = "NIXOS_DEPLOY_KEY"
  plaintext_value = tls_private_key.nixos_deploy_key.private_key_openssh
}

resource "github_actions_secret" "ssh_config" {
  repository      = "nixfiles"
  secret_name     = "SSH_CONFIG"
  plaintext_value = <<-EOF
  %{for host, data in module.host~}
  %{if data.type == "remote"~}
  Host ${host}
    HostName ${module.host[host].ipv4}
  %{endif~}
  %{endfor}
  EOF 
}

resource "github_actions_secret" "ssh_known_hosts" {
  repository      = "nixfiles"
  secret_name     = "SSH_KNOWN_HOSTS"
  plaintext_value = <<-EOF
  %{for host, data in module.host~}
  %{if data.type == "remote"~}
  ${module.host[host].ipv4} ${module.host[host].host_rsa_key_pub}
  ${module.host[host].ipv4} ${module.host[host].host_ed25519_key_pub}
  %{endif~}
  %{endfor}
  EOF 
}

resource "github_actions_secret" "ntfy_token" {
  repository      = "nixfiles"
  secret_name     = "NTFY_TOKEN"
  plaintext_value = local.secrets.ntfy.token
}

locals {
  github_output = {
    deploy_key_pub = trimspace(tls_private_key.nixos_deploy_key.public_key_openssh)
  }
}
