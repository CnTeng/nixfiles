variable "account_id" {
  type = string
}

variable "name" {
  type = string
}

terraform {
  required_providers {
    cloudflare = { source = "registry.terraform.io/cloudflare/cloudflare" }
    aws        = { source = "registry.terraform.io/hashicorp/aws" }
  }
}

data "cloudflare_api_token_permission_groups" "all" {}

resource "aws_s3_bucket" "bucket" {
  bucket = var.name
}

resource "cloudflare_api_token" "r2_token" {
  name = "r2_${var.name}"
  policy {
    permission_groups = [
      data.cloudflare_api_token_permission_groups.all.r2["Workers R2 Storage Bucket Item Write"],
    ]
    resources = {
      "com.cloudflare.edge.r2.bucket.${var.account_id}_default_${var.name}" = "*"
    }
  }
}

output "endpoint" {
  value     = "https://${var.account_id}.r2.cloudflarestorage.com/${var.name}"
  sensitive = true
}

output "access_key" {
  value     = cloudflare_api_token.r2_token.id
  sensitive = true
}

output "secret_key" {
  value     = sha256(cloudflare_api_token.r2_token.value)
  sensitive = true
}
