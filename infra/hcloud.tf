locals {
  rxhc = {
    rxhc0 = { plan = "cax21", region = "fsn1-dc14" }
  }
}

module "hcloud" {
  source   = "./modules/hcloud"
  for_each = local.rxhc
  hostname = each.key
  plan     = each.value.plan
  region   = each.value.region
}

output "rxhc" {
  value = module.hcloud
}
