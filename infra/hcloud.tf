provider "hcloud" {
  token = local.secrets.hcloud.hcloud_token
}
