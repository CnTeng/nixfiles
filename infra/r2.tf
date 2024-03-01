module "r2" {
  source     = "./modules/r2"
  providers  = { aws = aws.r2 }
  account_id = local.secrets.cloudflare.account_id
  name       = "backups"
}
