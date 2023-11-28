{ config, inputs, lib, ... }:
with lib;
let cfg = config.basics'.nix;
in {
  options.basics'.nix.enable = mkEnableOption "nix config" // {
    default = true;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      nix = {
        settings = {
          nix-path = [ "nixpkgs=${inputs.nixpkgs}" ];
          auto-optimise-store = true;
          builders-use-substitutes = true;
          experimental-features = [
            "auto-allocate-uids"
            "ca-derivations"
            "cgroups"
            "flakes"
            "nix-command"
          ];
          trusted-users = [ "root" "@wheel" ];
          auto-allocate-uids = true;
          use-cgroups = true;
          use-xdg-base-directories = true;
          trusted-public-keys =
            [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
          substituters = [ "https://cache.garnix.io" ];
        };
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
        };
      };

      nix.channel.enable = false;

      nix.registry.nixpkgs.flake = inputs.nixpkgs;
    })
    (mkIf config.hardware'.persist.enable {
      environment.variables.NIX_REMOTE = "daemon";

      systemd.services.nix-daemon = {
        environment.TMPDIR = "/var/cache/nix";
        serviceConfig.CacheDirectory = "nix";
      };
    })
  ];
}
