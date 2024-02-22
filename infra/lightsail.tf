locals {
  rxls = {
    lssg = { plan = "nano_3_0", region = "ap-southeast-1a" }
  }
}

module "lightsail" {
  source   = "./modules/lightsail"
  for_each = local.rxls
  hostname = each.key
  plan     = each.value.plan
  region   = each.value.region
}
