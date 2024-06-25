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

variable "disk_key" {
  type      = string
  sensitive = true
}

variable "host_key" {
  type = object({
    rsa_key = object({
      public_key  = string
      private_key = string
    })
    ed25519_key = object({
      public_key  = string
      private_key = string
    })
  })
  sensitive = true
}

variable "initrd_host_key" {
  type = object({
    rsa_key = object({
      public_key  = string
      private_key = string
    })
    ed25519_key = object({
      public_key  = string
      private_key = string
    })
  })
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
  ssh_private_key    = var.temp_private_key
  extra_files_script = "${path.module}/scripts/deploy-host-keys.sh"
  disk_encryption_key_scripts = [{
    path   = "/tmp/disk.key"
    script = "${path.module}/scripts/deploy-disk-key.sh"
  }]
  extra_environment = {
    DISK_KEY                   = var.disk_key
    RSA_PUBLIC_KEY             = var.host_key.rsa_key.public_key
    RSA_PRIVATE_KEY            = var.host_key.rsa_key.private_key
    ED25519_PUBLIC_KEY         = var.host_key.ed25519_key.public_key
    ED25519_PRIVATE_KEY        = var.host_key.ed25519_key.private_key
    INITRD_RSA_PUBLIC_KEY      = var.initrd_host_key.rsa_key.public_key
    INITRD_RSA_PRIVATE_KEY     = var.initrd_host_key.rsa_key.private_key
    INITRD_ED25519_PUBLIC_KEY  = var.initrd_host_key.ed25519_key.public_key
    INITRD_ED25519_PRIVATE_KEY = var.initrd_host_key.ed25519_key.private_key
  }
  build_on_remote = true
}
