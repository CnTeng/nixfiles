variable "syncthing" {
  type = bool
}

resource "shell_script" "generate_syncthing_config" {
  count = var.syncthing ? 1 : 0

  lifecycle_commands {
    create = file("${path.module}/scripts/generate-syncthing-config.sh")
    delete = ""
  }
}

output "syncthing" {
  value = var.syncthing
}

output "syncthing_id" {
  value = one(shell_script.generate_syncthing_config[*].output.device_id)
}

output "syncthing_key_pair" {
  value = {
    cert = one(shell_script.generate_syncthing_config[*].output.cert_pem)
    key  = one(shell_script.generate_syncthing_config[*].output.key_pem)
  }
  sensitive = true
}
