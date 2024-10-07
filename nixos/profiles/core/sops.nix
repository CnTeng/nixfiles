{ inputs, user, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  sops = {
    defaultSopsFile = ../../../infra/outputs/secrets.yaml;
    age = {
      sshKeyPaths = [ ];
      keyFile = "/var/lib/sops-nix/key";
    };
    gnupg.sshKeyPaths = [ ];
  };

  environment.persistence."/persist" = {
    users.${user}.directories = [ ".config/sops" ];
  };
}
