{ config, inputs, lib, ... }:
with lib;
let
  cfg = config.core'.nix;
  inherit (config.hardware') persist;
in {
  options.core'.nix.enable = mkEnableOption' { default = true; };

  config = mkIf cfg.enable {
    nix.settings = {
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
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    nix.channel.enable = false;
    nix.registry.nixpkgs.flake = inputs.nixpkgs;

    environment.variables.NIX_REMOTE = mkIf persist.enable "daemon";
    systemd.services.nix-daemon = mkIf persist.enable {
      environment.TMPDIR = "/var/cache/nix";
      serviceConfig.CacheDirectory = "nix";
    };
  };
}
