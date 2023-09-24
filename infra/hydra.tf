resource "hydra_project" "nixfiles" {
  name         = "nixfiles"
  display_name = "nixfiles"
  description  = "nixos config"
  owner        = "yufei"
}

resource "hydra_jobset" "nixfiles" {
  project           = hydra_project.nixfiles.name
  state             = "enabled"
  visible           = true
  name              = "nixfiles"
  type              = "flake"
  flake_uri         = "github:CnTeng/nixfiles/main"
  check_interval    = 120
  scheduling_shares = 100
  keep_evaluations  = 3
}
