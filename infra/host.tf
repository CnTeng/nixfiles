locals {
  hcloud = {
    hcax = {
      plan       = "cax21"
      region     = "fsn1-dc14"
      system     = "aarch64-linux"
      type       = "remote"
      openssh    = true
      initrd_ssh = true
      syncthing  = true
      nixbuild   = true
    }
  }

  lightsail = {
    lssg = {
      plan       = "nano_3_0"
      region     = "ap-southeast-1a"
      system     = "x86_64-linux"
      type       = "remote"
      openssh    = true
      initrd_ssh = false
      syncthing  = false
      nixbuild   = false
    }
  }

  local = {
    rxtp = {
      system     = "x86_64-linux"
      type       = "local"
      openssh    = true
      initrd_ssh = false
      syncthing  = true
      nixbuild   = false
    }

    rxop = {
      system     = "x86_64-linux"
      type       = "local"
      openssh    = false
      initrd_ssh = false
      syncthing  = true
      nixbuild   = false
    }
  }

  hosts             = merge(local.hcloud, local.lightsail, local.local)
  hosts_ip          = { for host, outputs in merge(module.hcloud, module.lightsail) : host => outputs.ip }
  temp_private_keys = { for host, outputs in module.hcloud : host => outputs.temp_private_key }
}

module "hcloud" {
  source   = "./modules/hcloud"
  for_each = local.hcloud

  hostname = each.key
  plan     = each.value.plan
  region   = each.value.region
}

module "lightsail" {
  source   = "./modules/lightsail"
  for_each = local.lightsail

  hostname = each.key
  plan     = each.value.plan
  region   = each.value.region
}

module "host" {
  source   = "./modules/host"
  for_each = local.hosts

  name       = each.key
  system     = each.value.system
  type       = each.value.type
  ip         = lookup(local.hosts_ip, each.key, null)
  openssh    = each.value.openssh
  initrd_ssh = each.value.initrd_ssh
  syncthing  = each.value.syncthing
  nixbuild   = each.value.nixbuild
}

module "nixos" {
  source     = "./modules/nixos"
  depends_on = [null_resource.output]
  for_each   = local.hcloud

  hostname         = each.key
  host_ip          = module.host[each.key].ip.ipv4
  temp_private_key = local.temp_private_keys[each.key]
  disk_key         = local.secrets.disk_keys[each.key]
  host_key = {
    rsa_key     = module.host[each.key].host_rsa_key
    ed25519_key = module.host[each.key].host_ed25519_key
  }
  initrd_key = {
    rsa_key     = module.host[each.key].initrd_rsa_key
    ed25519_key = module.host[each.key].initrd_ed25519_key
  }
}
