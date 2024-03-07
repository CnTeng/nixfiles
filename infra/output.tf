output "hosts" {
  value     = merge(module.hcloud, module.lightsail)
  sensitive = true
}

output "r2" {
  value     = module.r2
  sensitive = true
}
