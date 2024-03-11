{ inputs, user, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  sops.defaultSopsFile = ../../../infra/output.yaml;

  environment.persistence."/persist" = {
    users.${user}.directories = [ ".config/sops" ];
  };
}
