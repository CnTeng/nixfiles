output "hosts" {
  value = merge(module.hcloud, module.lightsail)
}

output "r2" {
  value     = module.r2
  sensitive = true
}
