locals {
  rxls = {
    rxls0 = {
      plan   = "micro_3_0"
      region = "ap-northeast-1a"
    }
  }
}

module "lightsail" {
  source   = "./modules/lightsail"
  for_each = local.rxls
  hostname = each.key
  plan     = each.value.plan
  region   = each.value.region
}

module "lightsail_cf_v4" {
  source   = "./modules/dns"
  for_each = module.lightsail
  zone_id  = module.zone["sp_xyz"].id
  name     = each.key
  value    = each.value.ipv4
  proxied  = false
}

module "lightsail_cf_v6" {
  source   = "./modules/dns"
  for_each = module.lightsail
  zone_id  = module.zone["sp_xyz"].id
  name     = each.key
  value    = each.value.ipv6[0]
  type     = "AAAA"
  proxied  = false
}

output "rxls" {
  value = module.lightsail
}
