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

module "lightsail_cf" {
  source   = "./modules/cloudflare"
  for_each = module.lightsail
  zone_id  = local.secrets.cloudflare.zone_id
  name     = each.key
  value    = each.value.ipv4
  proxied  = false
}

output "rxls" {
  value = module.lightsail
}
