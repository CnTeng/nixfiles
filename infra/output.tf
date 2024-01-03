output "hosts" {
  value = merge(module.hcloud, module.lightsail)
}
