provider "hcloud" {
  token = local.secrets.hcloud.hcloud_token
}

data "hcloud_server" "rxhz0" {
  name = "rxhz0"
}
