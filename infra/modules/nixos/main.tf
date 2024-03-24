variable "hostname" {
  type = string
}

variable "host_ip" {
  type = string
}

variable "private_key" {
  type = string
}

terraform {
  required_providers {
    external = { source = "registry.terraform.io/hashicorp/external" }
    null     = { source = "registry.terraform.io/hashicorp/null" }
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
  ssh_private_key    = nonsensitive(var.private_key) // Show log when running
  extra_files_script = "${path.module}/decrypt-ssh-keys.sh"
  disk_encryption_key_scripts = [{
    path   = "/tmp/disk.key"
    script = "${path.module}/decrypt-disk-key.sh"
  }]
  extra_environment = {
    HOST_NAME = var.hostname
  }
  build_on_remote = true
}
