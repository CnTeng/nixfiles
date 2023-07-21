{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.basics'.nix;
in {
  options.basics'.nix.enable =
    mkEnableOption "nix config"
    // {
      default = true;
    };

  config = mkMerge [
    (mkIf cfg.enable {
      nix = {
        package = pkgs.nixUnstable;
        settings = {
          auto-optimise-store = true;
          builders-use-substitutes = true;
          experimental-features = [
            "auto-allocate-uids"
            "ca-derivations"
            "cgroups"
            "flakes"
            "nix-command"
          ];
          keep-derivations = true;
          keep-outputs = true;
          # substituters = ["https://cache.snakepi.xyz"];
          # trusted-public-keys = [
          #   "cache.snakepi.xyz-1:CnMDci45ncAX/kR+3RyxeRLYa+9cFHH+LrOhVEiE1ss="
          # ];
          trusted-users = ["root" "@wheel"];
          auto-allocate-uids = true;
          use-cgroups = true;
        };
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
        };
      };
    })
    (mkIf config.hardware'.stateless.enable {
      environment.variables.NIX_REMOTE = "daemon";

      systemd.services.nix-daemon = {
        environment.TMPDIR = "/var/cache/nix";
        serviceConfig.CacheDirectory = "nix";
      };
    })
  ];
}
