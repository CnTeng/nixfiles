locals {
  gh_repos = toset([
    "nixfiles",
    "rx-nvim",
  ])
}

resource "github_actions_secret" "nixos_deploy_key" {
  repository  = "nixfiles"
  secret_name = "NIXOS_DEPLOY_KEY"
  value       = tls_private_key.host_deploy_key.private_key_openssh
}

resource "github_actions_secret" "ssh_config" {
  repository  = "nixfiles"
  secret_name = "SSH_CONFIG"
  value       = <<-EOF
  %{for host, data in module.host~}
  %{if data.type == "remote"~}
  Host ${host}
    HostName ${module.host[host].ipv4}
  %{endif~}
  %{endfor}
  EOF
}

resource "github_actions_secret" "ssh_known_hosts" {
  repository  = "nixfiles"
  secret_name = "SSH_KNOWN_HOSTS"
  value       = <<-EOF
  %{for host, data in module.host~}
  %{if data.type == "remote"~}
  ${module.host[host].ipv4} ${module.host[host].host_rsa_key_pub}
  ${module.host[host].ipv4} ${module.host[host].host_ed25519_key_pub}
  %{endif~}
  %{endfor}
  EOF
}

resource "github_actions_variable" "niks3_server" {
  repository    = "nixfiles"
  variable_name = "NIKS3_SERVER"
  value         = "https://niks3.snakepi.xyz"
}

resource "github_actions_variable" "client_id" {
  for_each = local.gh_repos

  repository    = each.value
  variable_name = "CLIENT_ID"
  value         = local.secrets.github.client_id
}

resource "github_actions_secret" "app_private_key" {
  for_each = local.gh_repos

  repository  = each.value
  secret_name = "APP_PRIVATE_KEY"
  value       = local.secrets.github.app_private_key
}

resource "github_dependabot_secret" "app_private_key" {
  for_each = local.gh_repos

  repository  = each.value
  secret_name = "APP_PRIVATE_KEY"
  value       = local.secrets.github.app_private_key
}
