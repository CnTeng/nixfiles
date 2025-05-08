locals {
  hcloud = {
    hcde = {
      plan   = "cax11"
      region = "fsn1-dc14"
      system = "aarch64-linux"
      type   = "remote"
    }
  }

  lightsail = {
    lssg = {
      plan   = "nano_3_0"
      region = "ap-southeast-1a"
      system = "x86_64-linux"
      type   = "remote"
    }
  }

  local = {
    rxtp = {
      system = "x86_64-linux"
      type   = "local"
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

  zone_id = cloudflare_zone.zones["sp_xyz"].id
  name    = each.key
  system  = each.value.system
  type    = each.value.type
  ip      = lookup(local.hosts_ip, each.key, null)
}

locals {
  public_hosts_output = {
    for host, outputs in module.host :
    host => {
      for name, output in outputs :
      name => output if !issensitive(output)
    }
  }

  private_hosts_output = {
    for host, outputs in module.host :
    host => {
      for name, output in outputs :
      name => output if issensitive(output)
    }
  }
}
