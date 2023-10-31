locals {
  rxls = {
    rxls0 = { plan = "micro_3_0", region = "ap-northeast-1a" }
  }
}

module "lightsail" {
  source   = "./modules/lightsail"
  for_each = local.rxls
  hostname = each.key
  plan     = each.value.plan
  region   = each.value.region
}

output "rxls" {
  value = module.lightsail
}
