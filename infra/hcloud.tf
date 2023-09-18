locals {
  rxhc = {
    rxhc0 = {
      plan   = "cax21"
      region = "fsn1-dc14"
    }
  }
}

module "hcloud" {
  source   = "./modules/hcloud"
  for_each = local.rxhc
  hostname = each.key
  plan     = each.value.plan
  region   = each.value.region
}

module "hcloud_cf_v4" {
  source   = "./modules/dns"
  for_each = module.hcloud
  zone_id  = module.zone["sp_xyz"].id
  name     = each.key
  value    = each.value.ipv4
  proxied  = false
}

module "hcloud_cf_v6" {
  source   = "./modules/dns"
  for_each = module.hcloud
  zone_id  = module.zone["sp_xyz"].id
  name     = each.key
  value    = each.value.ipv6
  type     = "AAAA"
  proxied  = false
}

output "rxhc" {
  value = module.hcloud
}
