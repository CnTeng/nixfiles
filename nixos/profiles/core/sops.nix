{ inputs, user, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  sops.defaultSopsFile = ../../../infra/outputs/secrets.yaml;

  environment.persistence."/persist" = {
    users.${user}.directories = [ ".config/sops" ];
  };
}
