locals {
  rxhc = {
    hcax = { plan = "cax21", region = "fsn1-dc14" }
  }
}

module "hcloud" {
  source   = "./modules/hcloud"
  for_each = local.rxhc
  hostname = each.key
  plan     = each.value.plan
  region   = each.value.region
}

module "nixos" {
  source      = "./modules/nixos"
  for_each    = local.rxhc
  hostname    = each.key
  host_ip     = module.hcloud[each.key].ipv4
  private_key = module.hcloud[each.key].temp_private_key
}
