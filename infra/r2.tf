locals {
  rxr2 = {
    backups = {}
  }
}

module "r2" {
  source    = "./modules/r2"
  providers = { aws = aws.r2 }
  for_each  = local.rxr2

  account_id = local.secrets.cloudflare.account_id
  name       = each.key
}
