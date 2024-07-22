variable "hostname" {
  type = string
}

variable "host_ip" {
  type = string
}

variable "temp_private_key" {
  type      = string
  sensitive = true
}

variable "age_private_key" {
  type      = string
  sensitive = true
}

terraform {
  required_providers {
    external = { source = "registry.terraform.io/hashicorp/external" }
    null     = { source = "registry.terraform.io/hashicorp/null" }
    tls      = { source = "registry.terraform.io/hashicorp/tls" }
  }
}

module "system" {
  source    = "github.com/CnTeng/nixos-anywhere//terraform/nix-build?ref=opentofu"
  attribute = ".#nixosConfigurations.${var.hostname}.config.system.build.toplevel"
}

module "disko" {
  source    = "github.com/CnTeng/nixos-anywhere//terraform/nix-build?ref=opentofu"
  attribute = ".#nixosConfigurations.${var.hostname}.config.system.build.diskoScript"
}

module "install" {
  source             = "github.com/CnTeng/nixos-anywhere//terraform/install?ref=opentofu"
  nixos_system       = module.system.result.out
  nixos_partitioner  = module.disko.result.out
  target_host        = var.host_ip
  ssh_private_key    = nonsensitive(var.temp_private_key)
  extra_files_script = "${path.module}/scripts/deploy-age-key.sh"
  extra_environment = {
    AGE_PRIVATE_KEY = nonsensitive(var.age_private_key)
  }
  build_on_remote = true
}
