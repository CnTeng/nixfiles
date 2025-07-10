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
      plan   = "micro_3_0"
      region = "ap-southeast-1c"
      system = "x86_64-linux"
      type   = "remote"
    }
  }

  local = {
    rxrk = {
      system = "aarch64-linux"
      type   = "local"
    }

    rxtp = {
      system = "x86_64-linux"
      type   = "local"
    }
  }

  hosts    = merge(local.hcloud, local.lightsail, local.local)
  hosts_ip = { for host, outputs in merge(module.hcloud, module.lightsail) : host => outputs.ip }
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

  zone_id   = cloudflare_zone.zones["sp_xyz"].id
  zone_name = cloudflare_zone.zones["sp_xyz"].name
  name      = each.key
  system    = each.value.system
  type      = each.value.type
  ip        = lookup(local.hosts_ip, each.key, null)
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
