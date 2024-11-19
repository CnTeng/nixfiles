{
  config,
  data,
  lib,
  ...
}:
let
  inherit (config.networking) hostName;

  hosts = lib.filterAttrs (n: v: n != hostName && v.nixbuild) data.hosts;

  machineSecrets = lib.concatMapAttrs (host: _: {
    "nixbuild/${host}_private_key".key = "hosts/${host}/nixbuild_key";
  }) hosts;

  buildMachines = lib.mkBuildMachines (
    host: config.sops.secrets."nixbuild/${host}_private_key".path
  ) hosts;
in
{
  nix.channel.enable = false;

  nix.settings = {
    auto-allocate-uids = true;
    auto-optimise-store = true;
    builders-use-substitutes = true;
    experimental-features = [
      "auto-allocate-uids"
      "ca-derivations"
      "cgroups"
      "flakes"
      "nix-command"
    ];

    substituters = [ "https://cache.garnix.io" ];
    trusted-public-keys = [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
    trusted-users = [ "@wheel" ];
    use-cgroups = true;
    use-xdg-base-directories = true;
  };

  nix = {
    inherit buildMachines;
    distributedBuilds = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  sops.secrets = machineSecrets;
}
