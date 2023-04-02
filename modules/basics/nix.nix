{ config, lib, ... }:
with lib;
let cfg = config.basics'.nix;
in {
  options.basics'.nix = {
    enable = mkEnableOption "nix config" // { default = true; };
  };

  config = mkIf cfg.enable {
    nix = {
      settings = {
        auto-optimise-store = true;
        experimental-features = [ "nix-command" "flakes" ];
        keep-derivations = true;
        keep-outputs = true;
        substituters = [ "https://cache.snakepi.xyz" ];
        trusted-public-keys = [
          "cache.snakepi.xyz-1:CnMDci45ncAX/kR+3RyxeRLYa+9cFHH+LrOhVEiE1ss="
        ];
        trusted-users = [ "root" "@wheel" ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };

    system.stateVersion = "23.05";
  };
}
