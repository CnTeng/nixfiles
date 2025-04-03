{
  inputs,
  config,
  user,
  ...
}:
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  sops = {
    defaultSopsFile = ../../../infra/outputs/secrets.yaml;
    environment.HOME = config.users.users.${user}.home;
    age.keyFile = "/var/lib/sops-nix/key";
  };

  environment.persistence."/persist" = {
    users.${user}.directories = [ ".config/sops" ];
  };
}
