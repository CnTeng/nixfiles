{
  config,
  inputs,
  lib,
  ...
}:
with lib;
let
  cfg = config.core'.nix;
in
{
  options.core'.nix.enable = mkEnableOption' { default = true; };

  config = mkIf cfg.enable {
    nix.channel.enable = false;

    nix.registry.nixpkgs.flake = inputs.nixpkgs;

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
      nix-path = [ "nixpkgs=${inputs.nixpkgs}" ];
      substituters = [ "https://cache.garnix.io" ];
      trusted-public-keys = [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
      trusted-users = [
        "root"
        "@wheel"
      ];
      use-cgroups = true;
      use-xdg-base-directories = true;
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
